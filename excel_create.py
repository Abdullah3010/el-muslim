import json
import os
from openpyxl import Workbook
from openpyxl.styles import Alignment


# ========= CONFIG =========
BASE_PATH = "./assets/json/azkar"
INDEX_FILE = "azkar_catigories.json"
OUTPUT_EXCEL = "azkar.xlsx"

IGNORE_KEYS = {"reference","description"}  
REMOVE_COLUMNS = {"id", "category"}

# Final column order (MANDATORY)
COLUMN_ORDER = ["zekr", "count", "fadel_zeker"]

JOIN_LISTS_WITH_NEWLINE = True
# ==========================


def load_json(path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def flatten_json(data, parent_key="", sep="."):
    """
    Recursively flatten nested JSON
    """
    items = {}

    if isinstance(data, dict):
        for k, v in data.items():
            new_key = f"{parent_key}{sep}{k}" if parent_key else k
            items.update(flatten_json(v, new_key, sep))

    elif isinstance(data, list):
        if JOIN_LISTS_WITH_NEWLINE:
            items[parent_key] = "\n".join(
                json.dumps(i, ensure_ascii=False) if isinstance(i, (dict, list)) else str(i)
                for i in data
            )
        else:
            for i, v in enumerate(data):
                items.update(flatten_json(v, f"{parent_key}[{i}]", sep))

    else:
        items[parent_key] = data

    return items


def main():
    index_path = os.path.join(BASE_PATH, INDEX_FILE)
    index_data = load_json(index_path)

    wb = Workbook()
    wb.remove(wb.active)

    for meta in index_data:
        sheet_name = meta.get("arName", "Sheet")[:31]
        filename = meta.get("filename")

        if not filename:
            continue

        file_path = os.path.join(BASE_PATH, filename)
        if not os.path.exists(file_path):
            print(f"⚠ Missing file: {filename}")
            continue

        raw_data = load_json(file_path)
        if not isinstance(raw_data, list) or not raw_data:
            continue

        rows = []
        for row in raw_data:
            flat = flatten_json(row)

            # Remove ignored and unwanted columns
            flat = {
                k: v
                for k, v in flat.items()
                if k not in REMOVE_COLUMNS
                and k.split(".")[0] not in IGNORE_KEYS
            }

            rows.append(flat)

        # Enforce column order strictly
        columns = [c for c in COLUMN_ORDER if any(c in r for r in rows)]

        ws = wb.create_sheet(title=sheet_name)
        ws.append(columns)

        for row in rows:
            ws.append([row.get(col, "") for col in columns])

        # Wrap text & align
        for col in ws.columns:
            for cell in col:
                cell.alignment = Alignment(
                    wrap_text=True,
                    vertical="top"
                )

    wb.save(OUTPUT_EXCEL)
    print(f"✅ Excel created successfully: {OUTPUT_EXCEL}")


if __name__ == "__main__":
    main()
