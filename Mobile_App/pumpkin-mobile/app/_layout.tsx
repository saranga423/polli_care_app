import { Slot } from "expo-router";
import "../global.css";
import { PaperProvider } from "react-native-paper";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { useEffect } from "react";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import {
  requestNotificationPermission,
  scheduleDailyNotification,
} from "@/utils/NotificationHelper";

export default function RootLayout() {
  const queryClient = new QueryClient();

  useEffect(() => {
    async function setup() {
      const granted = await requestNotificationPermission();
      if (granted) {
        await scheduleDailyNotification();
      }
    }
    setup();
  }, []);

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <QueryClientProvider client={queryClient}>
        <PaperProvider>
          <Slot />
        </PaperProvider>
      </QueryClientProvider>
    </GestureHandlerRootView>
  );
}
