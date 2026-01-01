# Repository Guidelines

## 1️⃣ Project Fundamentals
- Flutter project uses structure similar MVC pattern (Data, Managers, Presentation, Sources)
- State management: **provider**
- Dependency Injection: **flutter_modular**
- App is **already running**
  - ❌ NEVER run `flutter run`
  - Hot reload is enabled
  - Mention **hot restart** only if required

---

## 2️⃣ Task Handling Rules
Before coding, ALWAYS:
1. Classify the task:
   - Bug / Feature / Refactor / Question / Research / Documentation / Style
2. Check context completeness
3. Define scope clearly:
   - Files affected
   - Expected impact
   - One-line approach
4. Proceed only when scope is clear or approved

---

## 3️⃣ Editing & Debugging Workflow (MANDATORY)

### 🔍 Research Phase
- Read the **entire file** before editing
- Search for:
  - Usages
  - Similar patterns
  - Dependencies
- Understand the **full context**

### 🧠 Planning Phase
- Identify the **root cause**
- Plan fix step-by-step
- Consider edge cases and side effects

### ⚡ Execution Phase
- Make precise edits
- Update **ALL affected locations**
- Match existing indentation and style

### 🎯 Completion Rules
- `flutter analyze` → **ZERO errors**
- Fix all errors immediately
- Never leave partial solutions
- Never abandon a task mid-way

---

## 4️⃣ Definition of Done (ALL REQUIRED)
- ✅ `flutter analyze` = 0 errors
- ✅ Logic mentally verified
- ✅ All usages updated (grep)
- ✅ Code generation done if needed
- ✅ Root cause fixed (not symptoms)
- ✅ Similar issues checked

## 5️⃣ Naming Conventions (STRICT)

### ❌ Forbidden
- No project prefixes
- No `Screen` suffix

### ✅ Required Prefixes
| Type | Prefix |
|----|----|
| Screen | `sn_` |
| Widget | `w_` |
| Form | `f_` |
| Manager | `mg_` |
| Param | `param_` |
| Entity | `e_` |
| Model | `m_` |

---

## 6️⃣ Import Rules
- ✅ Package imports ONLY
- ❌ No relative imports (`../`)
- ✅ Alphabetical order enforced by linter

---

## 7️⃣ Navigation Rules
- ❌ NEVER use string routes
- ✅ ALWAYS use `Modular.to` methods
- Navigation must be type-safe

---

## 8️⃣ Null Safety Rules
- ❌ NEVER use `!` unless 100% guaranteed
- ✅ Use `?.`, `??`, and null checks
- ❌ No unsafe casting (`as double`)
- ✅ Safe type conversions only

---

## 🔟 Localization Rules
- JSON must be **FLAT**
- ❌ No nested translations
- Use underscore keys:
  - `auth_email`
  - `home_welcome_message`
- Use `.translated` extension

---

## 1️⃣1️⃣ UI & Component Rules
- ❌ Never use Flutter widgets directly if shared exists
- ✅ Always use shared components:
- Shared UI lives in `core/widgets/`

---

## 1️⃣2️⃣ Screen & Widget Rules
- Screen max length: **300 lines**
- ❌ No function widgets
- ✅ Always extract widget classes
- Remove empty folders
- Feature widgets → feature folder
- Shared widgets → core/shared

---
