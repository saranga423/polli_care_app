import {
  View,
  Text,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  Image,
} from "react-native";
import React, { useEffect, useState } from "react";
import ScreenWrapper from "@/components/ScreenWrapper";
import { StatusBar } from "expo-status-bar";
import { Ionicons as Icon } from "@expo/vector-icons";
import { useGetCurrentOperationStatus, useUpdateRover } from "@/utils/api";
import { RoverStatus } from "@/utils/types/Types";
import Images from "@/constants/Images";

const Home = () => {
  const [status, setStatus] = useState();
  const currentRoverId = "1";
  const userId = 1;

  const { data: operationStatus } =
    useGetCurrentOperationStatus(currentRoverId);

  useEffect(() => {
    if (operationStatus) {
      setStatus(operationStatus[0]?.roverStatus);
    }
  }, [operationStatus]);

  const handleSuccess = () => {
    Alert.alert("Success", "Rover Status Updated Successfully");
  };

  const handleError = () => {
    Alert.alert(
      "Error Updating Rover Status",
      updateRoverError ? updateRoverError.toString() : "Unknown error",
    );
  };

  const {
    mutate: updateRover,
    isPending: updateRoverPending,
    error: updateRoverError,
  } = useUpdateRover(currentRoverId, handleSuccess, handleError);

  const handleUpdateRoverStatus = (roverStatus: number) => {
    const payload = {
      initialId: 1,
      roverStatus: roverStatus,
      userId: userId,
    };
    updateRover(payload);
  };

  const selectRoverStatus = (status: number) => {
    switch (status) {
      case RoverStatus.START:
        return "Running";
      case RoverStatus.STOP:
        return "Stopped";
      default:
        return "";
    }
  };

  return (
    <ScreenWrapper>
      <View className="mb-6">
        <Text className="text-gray-900 mb-3 font-bold text-4xl text-left">
          Welcome Back
        </Text>
        <Text className="text-gray-500 text-xl font-medium">
          Ready to start today's pollination routine?
        </Text>
      </View>
      <View className="items-center my-10">
        <Image
          source={Images.rover}
          className="w-72 h-72 border border-gray-400 rounded-xl"
        />
      </View>
      <View className="flex flex-col justify-around items-center border rounded-full py-4 bg-gray-100 border-gray-400">
        <View className="flex flex-col gap-5 p-5 items-center">
          <View className="bg-yellow-500 w-60 h-16 rounded-full flex flex-row justify-center items-center gap-8">
            <View
              className={`w-3 h-3 ${
                status === RoverStatus.START ? "bg-green-500" : "bg-red-500"
              } rounded-full animate-pulse`}
            ></View>
            {updateRoverPending ? (
              <ActivityIndicator size="large" />
            ) : (
              <Text className="text-2xl text-white text-center">
                {selectRoverStatus(status ?? 0)}
              </Text>
            )}
          </View>
        </View>
        <View
          className={`rounded-full p-5 ${status === RoverStatus.START ? "bg-red-500" : "bg-[#52A756]"}`}
        >
          <TouchableOpacity
            onPress={() => {
              status === RoverStatus.START
                ? handleUpdateRoverStatus(RoverStatus.STOP)
                : handleUpdateRoverStatus(RoverStatus.START);
            }}
          >
            <Icon
              name={
                status === RoverStatus.START ? `stop-outline` : `power-outline`
              }
              size={70}
              color="white"
            />
          </TouchableOpacity>
        </View>
      </View>
      <StatusBar style="light" />
    </ScreenWrapper>
  );
};

export default Home;
