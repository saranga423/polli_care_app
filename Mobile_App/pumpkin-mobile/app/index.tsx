import { View, Text, ImageBackground } from "react-native";
import React from "react";
import { StatusBar } from "expo-status-bar";
import CustomButton from "@/components/CustomButton";
import { router } from "expo-router";
import Images from "@/constants/Images";
import { SafeAreaView } from "react-native-safe-area-context";
import { LinearGradient } from "expo-linear-gradient";

const App = () => {
  return (
    <ImageBackground
      source={Images.primaryBackground}
      resizeMode="cover"
      className="flex-1"
    >
      <LinearGradient
        colors={["rgba(0,0,0,0.4)", "rgba(0,0,0,0.8)"]}
        className="flex-1"
      >
        <SafeAreaView className="flex-1 p-1 justify-between">
          <View>
            <Text className="text-center text-white font-bold text-4xl">
              Pumpkin Pollinator
            </Text>
            <Text className="text-center text-white font-normal text-2xl mt-3">
              Automating pollination for Smart Farming
            </Text>
          </View>
          <View>
            <CustomButton
              onPress={() => router.push("/home")}
              label="Get Started"
              textStyles="text-white"
            />
          </View>
          <StatusBar style="light" />
        </SafeAreaView>
      </LinearGradient>
    </ImageBackground>
  );
};

export default App;
