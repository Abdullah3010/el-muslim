# Task: Integrate Aladhan Prayer Times API in Flutter (Dynamic Method by Lat/Lon)

You are an AI coding agent working inside a Flutter project.

## 🎯 Goal
Integrate **Aladhan Prayer Times API** into the Flutter app to fetch and display daily prayer times using:
- **GPS coordinates (latitude / longitude)**
- **Dynamic calculation method** based on the detected country from the user location

API Documentation:
- https://aladhan.com/prayer-times-api

---

## ✅ Requirements (Must Do)

### 1) Dependencies
Add these dependencies in `pubspec.yaml` (if not already installed):
- `dio` (HTTP requests)
- `geolocator` (GPS location)
- `geocoding` (reverse geocoding: lat/lon → country code)
- `intl` (optional formatting)

Example:
```yaml
dependencies:
  dio: ^5.7.0
  geolocator: ^13.0.2
  geocoding: ^3.0.0
  intl: ^0.19.0
Then run:

bash
Copy code
flutter pub get
2) API Endpoint (By Lat/Lon)
Use this endpoint:

GET https://api.aladhan.com/v1/timings

Query params:

latitude

longitude

method

Example:

bash
Copy code
https://api.aladhan.com/v1/timings?latitude=30.0444&longitude=31.2357&method=5
3) Prayer Methods List (Use EXACT mapping below)
The app must support these method IDs:

0 - Jafari / Shia Ithna-Ashari
1 - University of Islamic Sciences, Karachi
2 - Islamic Society of North America
3 - Muslim World League
4 - Umm Al-Qura University, Makkah
5 - Egyptian General Authority of Survey
7 - Institute of Geophysics, University of Tehran
8 - Gulf Region
9 - Kuwait
10 - Qatar
11 - Majlis Ugama Islam Singapura, Singapore
12 - Union Organization islamic de France
13 - Diyanet İşleri Başkanlığı, Turkey
14 - Spiritual Administration of Muslims of Russia
15 - Moonsighting Committee Worldwide (requires shafaq parameter)
16 - Dubai (experimental)
17 - Jabatan Kemajuan Islam Malaysia (JAKIM)
18 - Tunisia
19 - Algeria
20 - KEMENAG - Kementerian Agama Republik Indonesia
21 - Morocco
22 - Comunidade Islamica de Lisboa
23 - Ministry of Awqaf, Islamic Affairs and Holy Places, Jordan

4) Dynamic Method Selection Logic (Country → Method)
Implement a helper function:

Detect country code from lat/lon using reverse geocoding (Placemark.isoCountryCode)

Map country code to method based on common rules:

Use this mapping:

EG → 5

SA → 4

AE → 16

QA → 10

KW → 9

BH, OM → 8

TN → 18

DZ → 19

MA → 21

JO → 23

TR → 13

RU → 14

IR → 7

PK, IN, BD → 1

SG → 11

MY → 17

ID → 20

FR → 12

PT → 22

Default fallback → 3 (Muslim World League)

Create a file like:
lib/features/prayer_times/prayer_method_mapper.dart

With a function:

dart
Copy code
int getPrayerMethodByCountryCode(String? code);
5) Location Handling (Permissions + Errors)
Implement a location service that:

checks if location services are enabled

requests permission if needed

throws clear exceptions for:

services disabled

denied

denied forever

Recommended package: geolocator

6) Create Prayer Times Model
Create a model to parse response from:

response.data["data"]["timings"]

Extract at least:

Fajr

Dhuhr

Asr

Maghrib

Isha

Optional:

Sunrise

Imsak

Midnight

Also clean time values if they include timezone like "05:12 (EET)" by keeping only the HH:mm part.

7) Create API Service (Dio)
Create a service file:
lib/features/prayer_times/prayer_times_service.dart

It should include:

baseUrl = https://api.aladhan.com/v1

method to call /timings with lat/lon/method

optional support for method 15 with shafaq

Example signature:

dart
Copy code
Future<PrayerTimesModel> getPrayerTimesByLocation({
  required double lat,
  required double lon,
  required int method,
  String? shafaq,
});
8) Build UI Screen
Create a screen/page that:

fetches current location

detects country code

selects method dynamically

fetches prayer times

displays prayer times in a clean list UI

shows loading state

shows error state

supports pull-to-refresh (optional)

File example:
lib/features/prayer_times/prayer_times_screen.dart

UI must show at least:

Country code (if available)

Selected method ID

Prayer times list

🧠 Additional Notes / Best Practices
Keep code clean and structured (feature-based folders)

Use try/catch and return meaningful error messages

Avoid hardcoding city/country (use GPS only)

Make sure the feature works on both Android and iOS

Add iOS permission keys if missing (Info.plist):

NSLocationWhenInUseUsageDescription

Add Android permission in AndroidManifest if needed:

ACCESS_FINE_LOCATION

ACCESS_COARSE_LOCATION

✅ Deliverables
The implementation is considered complete when:

App can request GPS permission and get lat/lon

App can detect the country code from coordinates

App chooses the correct prayer method dynamically

App fetches prayer times from Aladhan API successfully

App displays prayer times in the UI

🔍 Output
After finishing, provide:

List of files created/modified

Short explanation of how it works

Example API call used

Screenshot-friendly UI layout (simple and clean)

