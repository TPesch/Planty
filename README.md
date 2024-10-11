# Planty 🌱

Planty is a plant management app that helps users track their plant's watering schedules and provides timely reminders to ensure healthy plant growth. Built using the Flutter framework, Planty supports multiple platforms including Android and Windows.

## Features

- **Plant Management**: Add, edit, and view plants with detailed information (name, species, date of planting).
- **Dynamic Watering Schedules**: Set customizable watering intervals per plant.
- **Unique Plant Photos**: Assign individual photos to each plant for easy identification.
- **Reminder Notifications**: Automatic notifications to remind users when to water their plants.
- **Dark Mode**: Toggle between light and dark themes.
- **User-Friendly Interface**: Intuitive and easy-to-navigate UI with a bottom navigation bar.
- **Multi-Platform Support**: Works on Android and Windows.

## Table of Contents

- [Installation](#installation)
- [How It Works](#how-it-works)
- [File Structure](#file-structure)
- [Usage](#usage)
- [Contributing](#contributing)

## Installation

### Prerequisites

- **Flutter SDK**: Ensure you have Flutter installed. [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Android Studio or Visual Studio Code**: Recommended IDEs for Flutter development.
- **Android Emulator or Physical Device**: To run the app on Android.
- **Windows Desktop**: For running the app on Windows.

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/TPesch/Planty.git
   cd planty
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:
   - For Android:
     ```bash
     flutter run
     ```
   - For Windows:
     ```bash
     flutter run -d windows
     ```

## How It Works

Planty allows users to manage plants by adding new plants with details like name, species, and date of planting. Users can also set dynamic watering schedules for each plant and get reminders via notifications to water them.

Notifications are sent based on timers created using the `dart:async` package, and platform-specific notifications are handled using `flutter_local_notifications` for Android and `windows_notification` for Windows.

Users can toggle dark mode for better visibility and reduce eye strain.

## File Structure

Here's the structure of the project:

```plaintext
lib/
├── main.dart                    # Main entry point
├── models/
│   └── plant.dart               # Plant data model
├── providers/
│   ├── theme_provider.dart      # Manages theme settings (dark/light mode)
│   └── plant_model.dart         # Manages plant data and state
├── services/
│   ├── notification_service.dart# Handles notifications for Android & Windows
│   └── permission_service.dart  # Manages app permissions (camera, notifications)
├── pages/
│   ├── home_page.dart           # Main home screen
│   ├── plant_detail_page.dart   # View and edit plant details
│   ├── plant_edit_page.dart     # Edit existing plants
│   ├── plant_input_page.dart    # Add new plants
│   ├── plant_list_page.dart     # View list of plants
│   └── test_notification_page.dart # Test notification functionality
└── widgets/
    └── permission_denied_widget.dart # Handles permission denied state UI
```

## Usage

1. **Add a New Plant**: Go to the "Add Plant" tab, fill in the plant's name, species, and date of planting, and set a watering schedule.
2. **View and Manage Plants**: View the list of plants and toggle watering status by clicking on a plant. You can also edit plant details or delete them.
3. **Receive Notifications**: Based on the watering schedule, notifications will remind you when it's time to water your plants.
4. **Test Notifications**: Use the "Test Notifications" tab to verify that notifications are working.

## Contributing

If you wish to contribute to Planty, follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes and commit them:
   ```bash
   git commit -m 'Add your message here'
   ```
4. Push to your branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a Pull Request.
