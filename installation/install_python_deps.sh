#!/bin/bash
# save as: install_python_deps.sh

echo "=== Installing Python Dependencies ==="

# Update pip
pip3 install --upgrade pip

# Core dependencies
pip3 install \
  pymavlink \
  opencv-python \
  opencv-contrib-python \
  pygame \
  ultralytics \
  numpy \
  scipy \
  simple-pid

# Sonar library (Ping protocol)
pip3 install bluerobotics-ping

# Utils
pip3 install \
  pyserial \
  pyyaml \
  matplotlib

echo "✓ Python dependencies installed!"