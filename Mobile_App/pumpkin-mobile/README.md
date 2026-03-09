# Pumpkin Rover Mobile

## Project Setup

Follow these steps to set up and run the project on your local machine:

### Prerequisites

- Node.js (v16 or higher)
- npm or yarn
- Expo CLI (`npm install -g expo-cli`)
- Android Studio (for Android emulator) or Xcode (for iOS simulator)

### Installation

1. Install dependencies:

   ```bash
   npm install
   # or
   yarn install
   ```

2. Start the development server:

   ```bash
   expo start
   ```

3. Run the app on a device or emulator:
   - For Android:
     ```bash
     expo run:android
     ```
   - For iOS:
     ```bash
     expo run:ios
     ```

### Environment Variables

Ensure you have the correct environment variables set up. Create a `.env` file in the root directory and add the required variables.

---

## Notification Time Setup

The `NotificationHelper.ts` file contains the logic for scheduling notifications. To set the notification time, follow these steps:

1. Open the `NotificationHelper.ts` file located in the `utils/` directory:

   ```bash
   utils/NotificationHelper.ts
   ```

2. Locate the function responsible for scheduling notifications. For example:

   ```typescript
   export async function scheduleDailyNotification() {
     // Notification scheduling logic
   }
   ```

3. Modify the `trigger` to set your desired notification time. The `trigger` should be in a valid format (e.g., `hour: 8, minute: 0` for 8:00 AM).

4. Example usage:

   ```typescript
    trigger: {
      hour: 8,
      minute: 0,
      repeats: true,
    }
   ```

5. Ensure the notification permissions are granted on the device.
6. In order to test the notification you need to use Development Build since you cannot test it using Expo Go

---

## Building the APK

To build the APK for the project, follow these steps:

1. Ensure you have the `eas-cli` installed globally:

   ```bash
   npm install -g eas-cli
   ```

2. Log in to your Expo account:

   ```bash
   eas login
   ```

3. Configure the `eas.json` file for your build. Ensure the `android` section is properly set up for your build type (e.g., `development`, `preview`, or `production`).
   (Make sure to select `preview` for Building the APK)

4. Build the APK:

   ```bash
   eas build -p android --profile preview
   ```

5. Once the build is complete, download the APK from the link provided in the terminal output.
