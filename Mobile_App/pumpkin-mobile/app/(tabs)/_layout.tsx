import React from "react";
import { Tabs } from "expo-router";
import { Ionicons as Icon } from "@expo/vector-icons";

const TabLayout = () => {
  return (
    <Tabs screenOptions={{ tabBarShowLabel: false }}>
      <Tabs.Screen
        name="home"
        options={{
          title: "Home",
          headerShown: false,
          tabBarIcon: ({ color, focused }) => (
            <Icon
              name={focused ? "home" : "home-outline"}
              size={24}
              color={color}
            />
          ),
        }}
      />
      <Tabs.Screen
        name="images"
        options={{
          title: "Images",
          headerShown: false,
          tabBarIcon: ({ color, focused }) => (
            <Icon
              name={focused ? "images" : "images-outline"}
              size={24}
              color={color}
            />
          ),
        }}
      />
    </Tabs>
  );
};

export default TabLayout;
