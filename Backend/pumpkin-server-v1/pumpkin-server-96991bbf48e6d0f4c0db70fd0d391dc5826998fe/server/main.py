from fastapi import FastAPI
from ultralytics import YOLO
from pydantic import BaseModel
import cv2
import numpy as np
import os
import uuid
import base64

app = FastAPI()

model = YOLO("model/best.pt")

os.makedirs("detections", exist_ok=True)


class DetectionRequest(BaseModel):
    rover_id: int
    image: str


@app.post("/detect")
async def detect(request: DetectionRequest):

    try:

        # Decode base64 image
        image_bytes = base64.b64decode(request.image)

        nparr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        if img is None:
            return {
                "status": 0,
                "coordinates": [],
                "error": "failed to decode image"
            }

        h, w = img.shape[:2]

        results = model(img)

        detections = []

        boxes = results[0].boxes

        if boxes is not None:

            for box in boxes:

                x1, y1, x2, y2 = map(float, box.xyxy[0])
                conf = float(box.conf[0])

                cx = (x1 + x2) / 2 / w
                cy = (y1 + y2) / 2 / h

                if conf > 0.8:

                    detections.append({
                        "x": cx,
                        "y": cy,
                        "confidence": conf
                    })

        detections.sort(key=lambda x: x["confidence"], reverse=True)

        # Save detection image (temporary debugging)
        if detections:

            annotated = results[0].plot()

            filename = f"detections/{uuid.uuid4()}.jpg"

            cv2.imwrite(filename, annotated)

        return {
            "status": 1,
            "coordinates": detections
        }

    except Exception as e:

        return {
            "status": 0,
            "coordinates": [],
            "error": str(e)
        }