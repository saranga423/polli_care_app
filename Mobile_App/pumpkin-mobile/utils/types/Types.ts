export interface UpdateRoverPayloadType {
  initialId: number;
  roverStatus: number;
  userId: number;
}

export enum RoverStatus {
  STOP = 0,
  START = 1,
}

export interface Rover {
  roverId: number;
  nickname: string;
}

export interface RoverImageData {
  id: number;
  rover_id: number;
  random_id: number;
  temp: number;
  humidity: number;
  blob_url: string;
  image_data: string[];
  created_at: string;
}

export interface ImageData {
  id: number;
  imageUrl: string;
  createdAt: string;
  flowerCount: number;
}
