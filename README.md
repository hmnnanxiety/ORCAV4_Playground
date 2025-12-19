siap 😄
ini **README.md versi ringkas + termasuk panduan `.sh` script** (kenapa ada, cara pakai, dan aturan mainnya). Fokus **environment dalam repo**, ga kebanyakan teori.

---

```md
# ORCA V4 – SAUVC 2026 (Environment Repo)

Repository ini berisi **setup environment dan baseline workspace ROS2** untuk pengembangan ORCA V4 (SAUVC 2026).

Tujuan utama repo:
- Menyamakan **environment semua staff**
- Menyediakan **script setup otomatis**
- Menyediakan **workspace ROS2 siap build**

---

## 🖥️ Target Environment

### Development (Staff)
- Ubuntu 22.04
- ROS2 Humble
- Python 3

### Deployment
- Jetson Orin Nano Super
- Ubuntu 22.04 (JetPack 6.0)
- Pixhawk (ArduSub / MAVLink)

---

## 📦 Tech Stack

- ROS2 Humble
- Python
- MAVLink (Pixhawk)
- Gazebo Harmonic (opsional, simulasi)
- YOLO (vision)
- Blue Robotics Ping Sonar / Ping360

---

## 📁 Repository Structure

```

orca_v4_ws/
├── src/
│   ├── orca_control
│   ├── orca_navigation
│   ├── orca_vision
│   ├── orca_sonar
│   ├── orca_sensors
│   ├── orca_mavlink
│   ├── orca_msgs
│   └── orca_bringup
└── scripts/
├── install_ros2_humble.sh
├── install_python_deps.sh
├── install_gazebo.sh
└── install_ardupilot.sh

````

---

## 🧠 Tentang File `.sh`

File `.sh` adalah **shell script** yang berisi kumpulan command Linux untuk setup environment.

Kenapa pakai `.sh`:
- Setup cukup **1 command**
- Menghindari salah urutan install
- Bisa diulang & dipakai semua staff

> ⚠️ `.sh` **tidak auto-run**, harus dijalankan manual.

---

## ▶️ Cara Menjalankan Script `.sh`

### 1. Masuk ke folder `scripts`
```bash
cd orca_v4_ws/scripts
````

### 2. Beri permission execute (sekali saja)

```bash
chmod +x *.sh
```

Atau per file:

```bash
chmod +x install_ros2_humble.sh
```

### 3. Jalankan script

```bash
./install_ros2_humble.sh
```

Alternatif (kalau tidak pakai chmod):

```bash
bash install_ros2_humble.sh
```

---

## ⚙️ Urutan Setup Environment (WAJIB)

Jalankan **berurutan**:

```bash
./install_ros2_humble.sh
./install_python_deps.sh
```

Opsional (kalau perlu simulasi):

```bash
./install_gazebo.sh
./install_ardupilot.sh
```

---

## 🔨 Build Workspace ROS2

```bash
cd ~/orca_v4_ws
colcon build --symlink-install
source install/setup.bash
```

Agar otomatis setiap buka terminal:

```bash
echo "source ~/orca_v4_ws/install/setup.bash" >> ~/.bashrc
```

---

## 🔌 Pixhawk Quick Setup

```bash
ls /dev/ttyACM* /dev/ttyUSB*
sudo usermod -a -G dialout $USER
```

Logout → login ulang.

---

## ▶️ Minimal Test

```bash
ros2 launch orca_bringup minimal_test.launch.py
```

---

## ⚠️ Notes

* Script `.sh` **boleh dijalankan ulang** (aman)
* Jalankan script pakai **user biasa**, bukan root
* Jangan test thruster dengan propeller di darat

---

## 👥 Quick Start (Staff Baru)

1. Install Ubuntu 22.04
2. Clone repo
3. Jalankan semua script di `scripts/`
4. Build workspace
5. Done 🚀

```
