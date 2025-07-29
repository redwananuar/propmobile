import 'package:flutter/material.dart';

enum ActivityType {
  workOrderCompleted,
  workOrderStarted,
  workOrderAssigned,
  leaveRequested,
  bookingCreated,
  photoUploaded,
}

class Activity {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final String technicianName;
  final DateTime timestamp;
  final String? workOrderId;
  final String? photoUrl;
  final Map<String, dynamic>? metadata;

  Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.technicianName,
    required this.timestamp,
    this.workOrderId,
    this.photoUrl,
    this.metadata,
  });

  factory Activity.fromWorkOrderCompleted({
    required String id,
    required String workOrderId,
    required String workOrderTitle,
    required String technicianName,
    required DateTime completedAt,
    String? photoUrl,
  }) {
    return Activity(
      id: id,
      type: ActivityType.workOrderCompleted,
      title: 'Work Order Completed',
      description: '$workOrderTitle completed',
      technicianName: technicianName,
      timestamp: completedAt,
      workOrderId: workOrderId,
      photoUrl: photoUrl,
    );
  }

  factory Activity.fromWorkOrderStarted({
    required String id,
    required String workOrderId,
    required String workOrderTitle,
    required String technicianName,
    required DateTime startedAt,
  }) {
    return Activity(
      id: id,
      type: ActivityType.workOrderStarted,
      title: 'Work Order Started',
      description: '$workOrderTitle started',
      technicianName: technicianName,
      timestamp: startedAt,
      workOrderId: workOrderId,
    );
  }

  factory Activity.fromWorkOrderAssigned({
    required String id,
    required String workOrderId,
    required String workOrderTitle,
    required String technicianName,
    required DateTime assignedAt,
  }) {
    return Activity(
      id: id,
      type: ActivityType.workOrderAssigned,
      title: 'Work Order Assigned',
      description: '$workOrderTitle assigned',
      technicianName: technicianName,
      timestamp: assignedAt,
      workOrderId: workOrderId,
    );
  }

  IconData get icon {
    switch (type) {
      case ActivityType.workOrderCompleted:
        return Icons.check_circle;
      case ActivityType.workOrderStarted:
        return Icons.play_circle;
      case ActivityType.workOrderAssigned:
        return Icons.assignment;
      case ActivityType.leaveRequested:
        return Icons.event_busy;
      case ActivityType.bookingCreated:
        return Icons.calendar_today;
      case ActivityType.photoUploaded:
        return Icons.photo;
    }
  }

  Color get color {
    switch (type) {
      case ActivityType.workOrderCompleted:
        return const Color(0xFF10B981);
      case ActivityType.workOrderStarted:
        return const Color(0xFF3B82F6);
      case ActivityType.workOrderAssigned:
        return const Color(0xFFF59E0B);
      case ActivityType.leaveRequested:
        return const Color(0xFFEF4444);
      case ActivityType.bookingCreated:
        return const Color(0xFF8B5CF6);
      case ActivityType.photoUploaded:
        return const Color(0xFF06B6D4);
    }
  }
} 