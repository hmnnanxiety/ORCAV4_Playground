# ORCA V4 Staff Onboarding Guide

## Welcome to ORCA Programming Team! 🤖

---

## Table of Contents

1. [Environment Setup](#environment-setup)
2. [Understanding the System](#understanding-the-system)
3. [Development Workflow](#development-workflow)
4. [Testing Procedures](#testing-procedures)
5. [Common Tasks](#common-tasks)
6. [Troubleshooting](#troubleshooting)

---

### Hardware Access

**Development Setup (All staff):**
- Laptop/PC with Ubuntu 22.04
- Minimum 8GB RAM, 50GB free storage
- USB 3.0 port

**Testing Setup (Lead/Senior only):**
- Access to Jetson Orin Nano
- Access to Pixhawk + test rig
- Sensor connections

---

## Environment Setup

### Step 1: Install Ubuntu 22.04

**Option A: Bootable Flashdisk** (Recommended)
```bash
# Follow guide in Programmer Guide ORCA V3.pdf page 2
# Use 128GB flashdisk for better performance
```

**Option B: Dual Boot**
```bash
# More permanent but requires partitioning
# Tutorial: https://itsfoss.com/install-ubuntu-dual-boot-mode-windows/
```

**Option C: Virtual Machine** (Limited - for basic testing only)
```bash
# VMware Workstation or VirtualBox
# Allocate: 4GB RAM, 50GB storage
# Note: Cannot access USB devices
```

### Step 2: Install ROS2 Humble

```bash
# Download installation script
wget https://raw.githubusercontent.com/your-repo/scripts/install_ros2_humble.sh

# Make executable
chmod +x install_ros2_humble.sh

# Run (will take ~30 minutes)
./install_ros2_humble.sh

# Verify installation
ros2 --version
# Should show: ros2 cli version 0.18.x
```

### Step 3: Install Development Tools

```bash
# Visual Studio Code
sudo snap install code --classic

# Install ROS extensions
code --install-extension ms-python.python
code --install-extension ms-iot.vscode-ros

# Terminator (better terminal)
sudo apt install terminator -y

# Git setup
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 4: Clone Workspace

```bash
# Create workspace
mkdir -p ~/orca_v4_ws/src
cd ~/orca_v4_ws/src

# Clone repository (need access token)
git clone https://github.com/your-org/orca_v4.git .

# Install dependencies
cd ~/orca_v4_ws
rosdep install --from-paths src --ignore-src -r -y

# Build workspace
colcon build --symlink-install

# Source workspace
source install/setup.bash
echo "source ~/orca_v4_ws/install/setup.bash" >> ~/.bashrc
```

### Step 5: Install Gazebo (For Simulation)

```bash
# Download installation script
wget https://raw.githubusercontent.com/your-repo/scripts/install_gazebo.sh

# Run
chmod +x install_gazebo.sh
./install_gazebo.sh

# Verify
gz sim --version
```

---

## Understanding the System

### Architecture Overview

```
                    ┌─────────────────────────┐
                    │   Mission Control       │
                    │   (Your Code Here!)     │
                    └───────────┬─────────────┘
                                │
            ┌───────────────────┼───────────────────┐
            │                   │                   │
    ┌───────▼────────┐  ┌──────▼──────┐   ┌───────▼────────┐
    │  Vision System │  │   Control   │   │  Sonar System  │
    │  (YOLO, CV)    │  │   (PID)     │   │  (Ping360)     │
    └───────┬────────┘  └──────┬──────┘   └───────┬────────┘
            │                   │                   │
            └───────────────────┼───────────────────┘
                                │
                        ┌───────▼────────┐
                        │  MAVLink I/F   │
                        │  (Pixhawk)     │
                        └───────┬────────┘
                                │
                        ┌───────▼────────┐
                        │   Thrusters    │
                        └────────────────┘
```

### Package Structure

```
orca_v4_ws/
├── src/
│   ├── orca_msgs/          # Message definitions
│   ├── orca_control/       # PID, depth hold, heading hold
│   ├── orca_sensors/       # Depth, IMU, proximity
│   ├── orca_vision/        # Camera, YOLO detection
│   ├── orca_sonar/         # Ping sonar interface
│   ├── orca_mavlink/       # Pixhawk communication
│   ├── orca_navigation/    # Waypoint, path planning
│   └── orca_bringup/       # Launch files, configs
```

### Key Topics

| Topic | Type | Description |
|-------|------|-------------|
| `/cmd_vel` | `Twist` | Velocity commands (manual control) |
| `/depth_data` | `OrcaDepth` | Depth sensor readings |
| `/imu/data` | `Imu` | IMU orientation & angular velocity |
| `/camera/image_raw` | `Image` | Camera feed |
| `/vision/detections` | `ImagePoint` | YOLO detection results |
| `/sonar/scan` | `LaserScan` | Sonar 360° scan |
| `/sonar/obstacle_distance` | `Float32` | Nearest obstacle distance |

---

## Development Workflow

### Daily Workflow

```bash
# 1. Pull latest changes
cd ~/orca_v4_ws/src
git pull

# 2. Create feature branch
git checkout -b feature/your-feature-name

# 3. Make changes
# ... edit code ...

# 4. Build and test
cd ~/orca_v4_ws
colcon build --packages-select orca_your_package
source install/setup.bash

# 5. Test in simulation
ros2 launch orca_bringup sim_test.launch.py

# 6. Commit and push
git add .
git commit -m "Description of changes"
git checkout -b 'your-branch'
git push origin 'your branch'

# 7. Create Pull Request on GitHub
```
TAG KADIV ATAU CAPTAIN UNTUK MERGE TO MAIN!

### Code Style

**Python:**
- Follow PEP 8
- Use type hints
- Add docstrings
- Maximum line length: 100 characters

**Example:**
```python
def calculate_distance(self, bbox_width: float) -> float:
    """
    Calculate distance to object from bounding box width.
    
    Args:
        bbox_width: Width of bounding box in pixels
        
    Returns:
        Distance in meters
    """
    if bbox_width == 0:
        return 0.0
    
    return (self.focal_length * self.real_width) / bbox_width
```

---

## Testing Procedures

### Test Levels

**Level 1: Unit Testing** (Your laptop)
```bash
# Test individual node
ros2 run orca_vision yolo_detector

# Monitor output
ros2 topic echo /vision/detections
```

**Level 2: Integration Testing** (Simulation)
```bash
# Launch full system in Gazebo
ros2 launch orca_bringup robot_sim.launch.py

# Test autonomous mission
ros2 run orca_navigation mission_runner
```

**Level 3: Hardware Testing** (With real robot - supervised)
```bash
# Launch on real hardware
ros2 launch orca_bringup robot_real.launch.py

# Always have emergency stop ready!
```

### Test Checklist

Before committing code:
- [ ] Code builds without errors
- [ ] Node starts without errors  
- [ ] Publishes expected topics
- [ ] Handles errors gracefully
- [ ] Logging is appropriate
- [ ] Tested in simulation (if applicable)

---

## Resources

### Documentation
- [ROS2 Humble Docs](https://docs.ros.org/en/humble/)
- [Ultralytics YOLO](https://docs.ultralytics.com/)
- [ArduSub Documentation](https://www.ardusub.com/)
- [MAVLink Protocol](https://mavlink.io/)

### Team Resources
- GitHub Repository: (internal link)
- Team Drive: (internal link)
- Meeting Schedule: (internal link)

**Good luck and happy coding! 🚀**