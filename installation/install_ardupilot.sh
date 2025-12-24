#!/bin/bash
# save as: install_ardupilot.sh

echo "=== Installing ArduPilot ==="

cd ~

# Clone ArduPilot
git clone --recurse-submodules https://github.com/ArduPilot/ardupilot.git
cd ardupilot

# Install prerequisites
Tools/environment_install/install-prereqs-ubuntu.sh -y

# Reload profile
. ~/.profile

echo "✓ ArduPilot installed!"

# Clone ArduPilot Gazebo plugin
cd ~
sudo apt install libgz-sim8-dev rapidjson-dev -y
sudo apt install libopencv-dev libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-bad \
  gstreamer1.0-libav gstreamer1.0-gl -y

git clone https://github.com/ArduPilot/ardupilot_gazebo
cd ardupilot_gazebo
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j4

# Add to bashrc
echo "export GZ_SIM_SYSTEM_PLUGIN_PATH=\$HOME/ardupilot_gazebo/build:\${GZ_SIM_SYSTEM_PLUGIN_PATH}" >> ~/.bashrc
echo "export GZ_SIM_RESOURCE_PATH=\$HOME/ardupilot_gazebo/models:\$HOME/ardupilot_gazebo/worlds:\${GZ_SIM_RESOURCE_PATH}" >> ~/.bashrc

source ~/.bashrc

echo "✓ ArduPilot Gazebo plugin installed!"