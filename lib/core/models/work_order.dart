class WorkOrder {
  final String id;
  final String type;
  final String title;
  final String description;
  final WorkOrderStatus status;
  final String? priority;
  final String? propertyUnit;
  final DateTime? scheduledDate;
  final String? scheduledStart;
  final String? scheduledEnd;
  final String technicianId;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? complaintId;
  final String? comment;
  final String? photoUrl;
  final String? location;

  WorkOrder({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    this.priority,
    this.propertyUnit,
    this.scheduledDate,
    this.scheduledStart,
    this.scheduledEnd,
    required this.technicianId,
    required this.createdAt,
    this.resolvedAt,
    this.complaintId,
    this.comment,
    this.photoUrl,
    this.location,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: WorkOrderStatus.values.firstWhere(
        (e) => e.databaseValue == json['status'],
        orElse: () => WorkOrderStatus.open,
      ),
      priority: json['priority'] as String?,
      propertyUnit: json['propertyUnit'] as String?,
      scheduledDate: json['scheduledDate'] != null 
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
      scheduledStart: json['scheduledStart'] as String?,
      scheduledEnd: json['scheduledEnd'] as String?,
      technicianId: json['technicianId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] != null 
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
      complaintId: json['complaintId'] as String?,
      comment: json['comment'] as String?,
      photoUrl: json['photoUrl'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'status': status.databaseValue,
      'priority': priority,
      'propertyUnit': propertyUnit,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'scheduledStart': scheduledStart,
      'scheduledEnd': scheduledEnd,
      'technicianId': technicianId,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'complaintId': complaintId,
      'comment': comment,
      'photoUrl': photoUrl,
      'location': location,
    };
  }

  WorkOrder copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    WorkOrderStatus? status,
    String? priority,
    String? propertyUnit,
    DateTime? scheduledDate,
    String? scheduledStart,
    String? scheduledEnd,
    String? technicianId,
    DateTime? createdAt,
    DateTime? resolvedAt,
    String? complaintId,
    String? comment,
    String? photoUrl,
    String? location,
  }) {
    return WorkOrder(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      propertyUnit: propertyUnit ?? this.propertyUnit,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      technicianId: technicianId ?? this.technicianId,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      complaintId: complaintId ?? this.complaintId,
      comment: comment ?? this.comment,
      photoUrl: photoUrl ?? this.photoUrl,
      location: location ?? this.location,
    );
  }

  // Helper methods for dashboard
  bool get isCompleted => status == WorkOrderStatus.completed;
  bool get isJob => type == 'job';
  bool get isComplaint => type == 'complaint';
  String get typeDisplayName => type == 'job' ? 'Job' : 'Complaint';
}

enum WorkOrderStatus {
  open,
  inProgress,
  completed,
}

extension WorkOrderStatusExtension on WorkOrderStatus {
  String get displayName {
    switch (this) {
      case WorkOrderStatus.open:
        return 'Open';
      case WorkOrderStatus.inProgress:
        return 'In Progress';
      case WorkOrderStatus.completed:
        return 'Completed';
    }
  }

  String get databaseValue {
    switch (this) {
      case WorkOrderStatus.open:
        return 'open';
      case WorkOrderStatus.inProgress:
        return 'in-progress';
      case WorkOrderStatus.completed:
        return 'completed';
    }
  }
} 