/// Support issue model for SalesIQ widget
class SupportIssue {
  final String id;
  final String? orderId;
  final String issueType;
  final String description;
  final String status;
  final String createdAt;
  final String? resolution;
  final String? assignedTo;
  final String priority;

  SupportIssue({
    required this.id,
    this.orderId,
    required this.issueType,
    required this.description,
    required this.status,
    required this.createdAt,
    this.resolution,
    this.assignedTo,
    this.priority = 'Medium',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'issueType': issueType,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'resolution': resolution,
      'assignedTo': assignedTo,
      'priority': priority,
    };
  }

  factory SupportIssue.fromJson(Map<String, dynamic> json) {
    return SupportIssue(
      id: json['id'] ?? '',
      orderId: json['orderId'],
      issueType: json['issueType'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Open',
      createdAt: json['createdAt'] ?? '',
      resolution: json['resolution'],
      assignedTo: json['assignedTo'],
      priority: json['priority'] ?? 'Medium',
    );
  }

  /// Check if issue is still open
  bool get isOpen => status.toLowerCase() == 'open';

  /// Check if issue is resolved
  bool get isResolved => status.toLowerCase() == 'resolved';

  /// Get priority level as integer (1=High, 2=Medium, 3=Low)
  int get priorityLevel {
    switch (priority.toLowerCase()) {
      case 'high':
        return 1;
      case 'medium':
        return 2;
      case 'low':
        return 3;
      default:
        return 2;
    }
  }
}
