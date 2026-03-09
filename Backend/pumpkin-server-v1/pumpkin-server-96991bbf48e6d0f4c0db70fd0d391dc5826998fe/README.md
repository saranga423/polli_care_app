# Overview

The project uses:

- YOLOv11 object detection
- Transfer learning with pretrained weights
- Custom-trained model for specific flower detection

# Getting Started

### 1. Put the `best.pt` file inside the `model` directory

### 2. Activate Virtual Environment

Check available Python
```
python3 --version
```

* if Python 3.11.x > then (for macOs)
```
brew install python@3.11
```

Create virtual evn for first time
```
python3.11 -m venv venv
```

Windows:

```bash
venv\Scripts\activate
```
Linux/Mac
```
source venv/bin/activate
```

### 3. Install Dependencies
```
pip install -r requirements.txt
```
* without CUDA support (for macOS)
```
pip install -r requirements-mac.t
```
### 4. Start Server
```
uvicorn server.main:app --reload
```
---
# Server

Server will run at
```
http://127.0.0.1:8000
```
### API documentation:
```
http://127.0.0.1:8000/docs
```

---

# IoT Device Communication
### Request format
```
{
  "rover_id": 0,
  "image": "/9j/4AAQSkZJRg..."
}
```
* use this site to encode JPG to Base64 format [base64.guru](https://base64.guru/converter/encode/image/jpg)
### Response format

```
{
  "status": 1,
  "coordinates": [
    {
      "x": 0.45,
      "y": 0.32,
      "confidence": 0.92
    }
  ]
}
```

* Check result images save on `detections` folder in root.

### Coordinates are normalized
```
0 → left/top
1 → right/bottom
```
