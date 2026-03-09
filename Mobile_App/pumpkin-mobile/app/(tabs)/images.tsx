import ScreenWrapper from "@/components/ScreenWrapper";
import { View, Text } from "react-native";
import { FlatList } from "react-native-gesture-handler";
import { Image } from "expo-image";
import data from "@/constants/imageData.json";

const Images = () => {
  return (
    <ScreenWrapper>
      <Text className="text-2xl font-bold text-center my-4">Images</Text>
      <FlatList
        data={data}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <View className="p-5 mb-5 rounded-2xl">
            <Image
              source={{ uri: item.imageUrl }}
              style={{ width: "100%", height: 200 }}
            />
            <Text className="text-center mt-2 text-gray-600">
              Captured: {new Date(item.createdAt).toLocaleString()}
            </Text>
            <Text className="text-center mt-2 text-gray-600">
              Flower Count: {item.flowerCount}
            </Text>
          </View>
        )}
      />
    </ScreenWrapper>
  );
};

export default Images;
