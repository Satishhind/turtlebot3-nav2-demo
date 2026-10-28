#!/usr/bin/env bash
# Checks ROS 2 + Gazebo + TurtleBot3 + Nav2 installation (Foxy by default)
D=${DISTRO:-foxy}
ok(){ echo "[PASS] $1"; }; bad(){ echo "[FAIL] $1"; FAIL=1; }
echo "OS: $(lsb_release -ds 2>/dev/null)"
[ -f /opt/ros/$D/setup.bash ] && { source /opt/ros/$D/setup.bash; ok "ROS 2 $D found"; } || { bad "ROS 2 $D not found in /opt/ros"; exit 1; }
[ "$ROS_DISTRO" = "$D" ] && ok "ROS_DISTRO=$ROS_DISTRO" || bad "ROS_DISTRO mismatch"
[ -n "$TURTLEBOT3_MODEL" ] && ok "TURTLEBOT3_MODEL=$TURTLEBOT3_MODEL" || bad "TURTLEBOT3_MODEL not set (export TURTLEBOT3_MODEL=waffle)"
echo "RMW_IMPLEMENTATION=${RMW_IMPLEMENTATION:-<default>}"
command -v ros2 >/dev/null && ok "ros2 CLI" || bad "ros2 CLI"
command -v gazebo >/dev/null && ok "Gazebo: $(gazebo --version 2>/dev/null | grep -i version | head -1)" || bad "gazebo binary"
for p in gazebo_ros turtlebot3_gazebo turtlebot3_description turtlebot3_navigation2 \
         nav2_bringup nav2_bt_navigator nav2_amcl nav2_planner nav2_controller nav2_map_server rviz2; do
  ros2 pkg prefix $p >/dev/null 2>&1 && ok "package $p" || bad "package $p missing (sudo apt install ros-$D-${p//_/-})"
done
M=/opt/ros/$D/share/nav2_bringup/maps/turtlebot3_world.yaml
[ -f $M ] && ok "map $M" || bad "map file missing: $M"
W=$(ros2 pkg prefix turtlebot3_gazebo 2>/dev/null)/share/turtlebot3_gazebo/launch/turtlebot3_world.launch.py
[ -f "$W" ] && ok "turtlebot3_world launch file" || bad "turtlebot3_world.launch.py missing"
dpkg -l | grep -q rmw-cyclonedds && ok "CycloneDDS installed" || echo "[WARN] CycloneDDS not installed (recommended for Foxy Nav2)"
echo; [ -z "$FAIL" ] && echo "All checks passed. Next: ./run_sim.sh" || echo "Some checks failed. Paste this output to Claude."
