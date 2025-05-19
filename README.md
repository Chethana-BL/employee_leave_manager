# 🧾 Employee Leave Manager (Flutter App)

A Flutter application to manage employee absences, including sickness and vacations. The app displays absence records with pagination, filtering, detailed info, and calendar export features — offering a seamless experience for company managers and HR teams.

---

## 🏗 Architecture Overview

The app follows a modular and scalable architecture using the **BLoC (Business Logic Component)** pattern for state management, enabling clean separation of concerns and testability.

- **Presentation Layer:** Flutter UI widgets with responsive design  
- **Business Logic Layer:** BLoC managing state, events, and transitions  
- **Data Layer:** Connects to a backend API (optionally supports local JSON)  
- **Testing:** Unit and widget tests using `flutter_test`

---

## ✨ Features

- Display a paginated list of absences (10 items per page)
- Show total number of absences
- View detailed absence info:
  - 👤 Employee name  
  - 📂 Absence type  
  - 📆 Period (from – to)  
  - 🕒 Number of days  
  - 🗒️ Member note (optional)  
  - ✅ Status: Requested, Confirmed, or Rejected  
  - 📝 Admitter note (optional)  
- Filter absences by:
  - Type  
  - Status  
  - Date range  
  - Employee
- iCal file generation and export feature for calendar integration
- Loading, error, and empty UI states based on API response

---

## 📡 Backend API

This app is powered by a custom [Express.js](https://expressjs.com/) API, deployed using **Render**.  
The API provides endpoints for absences and member data, with optional filters.

➡️ See full API details and setup in the [Backend README](https://github.com/Chethana-BL/leave_manager_backend/blob/main/README.md)

---

## 🌐 Live Demo

Access the deployed app here:  
🔗 [https://chethana-bl.github.io/employee_leave_manager/](https://chethana-bl.github.io/employee_leave_manager/)

*Note:* The app might take a few seconds to load initially

---

## ⚙️ Setup Instructions

### Prerequisites

- ✅ Flutter SDK (>= 3.0.0)  
- ✅ Dart SDK  
- ✅ A Flutter-compatible editor (VSCode, Android Studio)

**Clone the Repository**

```bash
git clone https://github.com/Chethana-BL/employee_leave_manager
cd employee_leave_manager
```

**Install Dependencies**

Run the following to install required packages:
```bash
flutter pub get
```

### Running the App

```bash
flutter run
```

To check code style and run all tests:

```bash
make check
```

---

## 📋 Assumptions & Notes

- The app fetches data from a live backend API (see above).
- Support for local mock JSON data remains available for fallback/testing.
- Pagination, filtering, and error states are implemented.
- iCal files are generated based on current filtered absences.

---

## 🧪 Evaluations

- ✅ Fully implemented all mandatory product requirements  
- ✅ Designed scalable architecture with BLoC  
- ✅ Applied Flutter best practices and linter rules  
- ✅ Included tests for logic and widgets  
- ✅ Integrated iCal generation and backend API support

---
