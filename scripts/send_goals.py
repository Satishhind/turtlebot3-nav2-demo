#!/usr/bin/env python3
"""Sends a sequence of goals to Nav2 (works on Foxy)."""
import rclpy
from rclpy.node import Node
from rclpy.action import ActionClient
from geometry_msgs.msg import PoseStamped
from nav2_msgs.action import NavigateToPose

GOALS = [(1.7, -0.5), (0.5, 1.7), (-1.8, 1.5), (-2.0, -0.5)]  # edit if rejected

class Runner(Node):
    def __init__(self):
        super().__init__('goal_runner')
        self.set_parameters([rclpy.parameter.Parameter(
            'use_sim_time', rclpy.Parameter.Type.BOOL, True)])
        self.client = ActionClient(self, NavigateToPose, 'navigate_to_pose')

    def go(self, x, y):
        goal = NavigateToPose.Goal()
        goal.pose = PoseStamped()
        goal.pose.header.frame_id = 'map'
        goal.pose.header.stamp = self.get_clock().now().to_msg()
        goal.pose.pose.position.x, goal.pose.pose.position.y = x, y
        goal.pose.pose.orientation.w = 1.0
        fut = self.client.send_goal_async(goal)
        rclpy.spin_until_future_complete(self, fut)
        handle = fut.result()
        if not handle.accepted:
            self.get_logger().warn(f'Goal ({x}, {y}) rejected'); return
        res = handle.get_result_async()
        rclpy.spin_until_future_complete(self, res)
        self.get_logger().info(f'Goal ({x}, {y}) done, status={res.result().status} (4 = success)')

def main():
    rclpy.init()
    n = Runner()
    n.client.wait_for_server()
    for x, y in GOALS:
        n.go(x, y)
    rclpy.shutdown()

if __name__ == '__main__':
    main()

