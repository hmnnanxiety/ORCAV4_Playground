#!/bin/bash
# save as: install_gazebo.sh

echo "=== Installing Gazebo Harmonic ==="

# Add Gazebo repo
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] \
  http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

# Install
sudo apt update
sudo apt install gz-harmonic -y

# Test installation
gz sim --version

echo "✓ Gazebo Harmonic installed!"