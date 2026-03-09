import * as Notifications from "expo-notifications";

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: false,
    shouldSetBadge: false,
  }),
});

// Ask user for permission
export async function requestNotificationPermission() {
  const { status } = await Notifications.requestPermissionsAsync();
  return status === "granted";
}

// Schedule daily 8:00am notification
export async function scheduleDailyNotification() {
  // Cancel any existing ones first to avoid duplicates
  await Notifications.cancelAllScheduledNotificationsAsync();

  await Notifications.scheduleNotificationAsync({
    content: {
      title: "Good Morning! 👋",
      body: "Don't forget to start your pollination routine today!",
    },
    trigger: {
      hour: 8,
      minute: 0,
      repeats: true,
    },
  });
}
