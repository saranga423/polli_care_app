import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import axios from "axios";
import { UpdateRoverPayloadType } from "./types/Types";
import { BackendUrl } from "@/constants/Constants";

const getCurrentOperationStatus = async (roverId: string) => {
  try {
    const response = await axios.post(`${BackendUrl}/rover/${roverId}`);
    return response.data;
  } catch (error) {
    console.error("Error getting current rover operation status", error);
    throw error;
  }
};

export const useGetCurrentOperationStatus = (roverId: string) => {
  return useQuery({
    queryKey: ["rover-operation-status", roverId],
    queryFn: () => getCurrentOperationStatus(roverId),
  });
};

const updateRover = async (payload: UpdateRoverPayloadType) => {
  try {
    const response = await axios.post(`${BackendUrl}/rover/update`, payload);
    return response.data;
  } catch (error) {
    console.error("Error updating rover ", error);
    throw error;
  }
};

export const useUpdateRover = (
  roverId: string,
  onSuccess: () => void,
  onError: () => void,
) => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (payload: UpdateRoverPayloadType) => updateRover(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["rover-operation-status", roverId],
      });
      onSuccess();
    },
    onError,
  });
};
