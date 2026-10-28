#!/usr/bin/env bash
# Terminal 1: Gazebo + TurtleBot3 in turtlebot3_world
source /opt/ros/foxy/setup.bash
export TURTLEBOT3_MODEL=${TURTLEBOT3_MODEL:-burger}
export RMW_IMPLEMENTATION=${RMW_IMPLEMENTATION:-rmw_fastrtps_cpp}
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
