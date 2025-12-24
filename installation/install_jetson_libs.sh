#!/bin/bash
# save as: install_jetson_libs.sh

echo "=== Installing Jetson-specific libraries ==="

# GPIO access
sudo pip3 install Jetson.GPIO

# Add user to gpio group
sudo groupadd -f -r gpio
sudo usermod -a -G gpio $USER

# Camera support (for B-Pro camera)
sudo apt install v4l-utils -y

# GStreamer (hardware-accelerated video)
sudo apt install \
  gstreamer1.0-tools \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav -y

# CUDA-enabled OpenCV (optional, for GPU acceleration)
# Already included in JetPack, verify:
python3 -c "import cv2; print(cv2.getBuildInformation())" | grep -i cuda

echo "✓ Jetson libraries installed!"
```

#### **D. Connect Pixhawk to Jetson**

**Hardware Connection:**
```
Pixhawk TELEM2 ─────── USB-to-TTL Adapter ─────── Jetson USB-C
   TX  ────────────────────── RX
   RX  ────────────────────── TX
   GND ────────────────────── GND
```

**Or simpler (recommended):**
```
Pixhawk USB ─────── USB-C Cable ─────── Jetson USB 3.0