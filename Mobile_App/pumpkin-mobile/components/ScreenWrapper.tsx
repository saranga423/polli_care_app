import React from "react";
import { SafeAreaView } from "react-native-safe-area-context";

const ScreenWrapper = ({ children }: { children: any }) => {
  return (
    <SafeAreaView className="flex-1 px-5 bg-white" testID="screen-wrapper">
      {children}
    </SafeAreaView>
  );
};

export default ScreenWrapper;
