#!/usr/bin/env bash
# Terminal 2: Nav2 + RViz on the pre-built turtlebot3_world map
source /opt/ros/foxy/setup.bash
export TURTLEBOT3_MODEL=${TURTLEBOT3_MODEL:-burger}
export RMW_IMPLEMENTATION=${RMW_IMPLEMENTATION:-rmw_fastrtps_cpp}
MAP=/opt/ros/foxy/share/nav2_bringup/maps/turtlebot3_world.yaml
ros2 launch turtlebot3_navigation2 navigation2.launch.py use_sim_time:=True map:=$MAP
