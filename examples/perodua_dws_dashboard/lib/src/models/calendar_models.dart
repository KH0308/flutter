import 'package:equatable/equatable.dart';

/// Represents a technician in the dashboard
class Technician extends Equatable {
  final String id;
  final String name;
  final String floor;
  final bool isAvailable;
  final String? specialization;

  const Technician({
    required this.id,
    required this.name,
    required this.floor,
    this.isAvailable = true,
    this.specialization,
  });

  @override
  List<Object?> get props => [id, name, floor, isAvailable, specialization];

  Technician copyWith({
    String? id,
    String? name,
    String? floor,
    bool? isAvailable,
    String? specialization,
  }) {
    return Technician(
      id: id ?? this.id,
      name: name ?? this.name,
      floor: floor ?? this.floor,
      isAvailable: isAvailable ?? this.isAvailable,
      specialization: specialization ?? this.specialization,
    );
  }
}

/// Represents the status of a job/event
enum JobStatus {
  pending,
  inProgress,
  completed,
  cancelled,
  waitingApproval,
}

/// Represents the type of service
enum ServiceType {
  maintenance,
  repair,
  inspection,
  installation,
  emergency,
}

/// Represents a calendar event
class CalendarEvent extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String technicianId;
  final ServiceType serviceType;
  final JobStatus status;
  final String? customerName;
  final String? vehicleInfo;
  final bool requiresApproval;
  final bool isApproved;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.technicianId,
    required this.serviceType,
    required this.status,
    this.customerName,
    this.vehicleInfo,
    this.requiresApproval = false,
    this.isApproved = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        technicianId,
        serviceType,
        status,
        customerName,
        vehicleInfo,
        requiresApproval,
        isApproved,
      ];

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? technicianId,
    ServiceType? serviceType,
    JobStatus? status,
    String? customerName,
    String? vehicleInfo,
    bool? requiresApproval,
    bool? isApproved,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      technicianId: technicianId ?? this.technicianId,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      isApproved: isApproved ?? this.isApproved,
    );
  }

  /// Get duration of the event in hours
  double get durationInHours {
    return endTime.difference(startTime).inMinutes / 60.0;
  }

  /// Check if event conflicts with another event
  bool conflictsWith(CalendarEvent other) {
    return technicianId == other.technicianId &&
        ((startTime.isBefore(other.endTime) && endTime.isAfter(other.startTime)) ||
            (other.startTime.isBefore(endTime) && other.endTime.isAfter(startTime)));
  }
}

/// Represents a waitlist entry
class WaitlistEntry extends Equatable {
  final String id;
  final String customerName;
  final String vehicleInfo;
  final ServiceType serviceType;
  final String description;
  final DateTime requestedDate;
  final int priority;

  const WaitlistEntry({
    required this.id,
    required this.customerName,
    required this.vehicleInfo,
    required this.serviceType,
    required this.description,
    required this.requestedDate,
    this.priority = 1,
  });

  @override
  List<Object> get props => [
        id,
        customerName,
        vehicleInfo,
        serviceType,
        description,
        requestedDate,
        priority,
      ];

  WaitlistEntry copyWith({
    String? id,
    String? customerName,
    String? vehicleInfo,
    ServiceType? serviceType,
    String? description,
    DateTime? requestedDate,
    int? priority,
  }) {
    return WaitlistEntry(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      requestedDate: requestedDate ?? this.requestedDate,
      priority: priority ?? this.priority,
    );
  }
}

/// Calendar filter settings
class CalendarFilters extends Equatable {
  final List<String> selectedFloors;
  final List<ServiceType> selectedServiceTypes;
  final List<JobStatus> selectedJobStatuses;
  final bool showOnlyAvailableTechnicians;
  final DateTime? dateRange;

  const CalendarFilters({
    this.selectedFloors = const [],
    this.selectedServiceTypes = const [],
    this.selectedJobStatuses = const [],
    this.showOnlyAvailableTechnicians = false,
    this.dateRange,
  });

  @override
  List<Object?> get props => [
        selectedFloors,
        selectedServiceTypes,
        selectedJobStatuses,
        showOnlyAvailableTechnicians,
        dateRange,
      ];

  CalendarFilters copyWith({
    List<String>? selectedFloors,
    List<ServiceType>? selectedServiceTypes,
    List<JobStatus>? selectedJobStatuses,
    bool? showOnlyAvailableTechnicians,
    DateTime? dateRange,
  }) {
    return CalendarFilters(
      selectedFloors: selectedFloors ?? this.selectedFloors,
      selectedServiceTypes: selectedServiceTypes ?? this.selectedServiceTypes,
      selectedJobStatuses: selectedJobStatuses ?? this.selectedJobStatuses,
      showOnlyAvailableTechnicians: showOnlyAvailableTechnicians ?? this.showOnlyAvailableTechnicians,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  /// Check if filters are empty (show all)
  bool get isEmpty {
    return selectedFloors.isEmpty &&
        selectedServiceTypes.isEmpty &&
        selectedJobStatuses.isEmpty &&
        !showOnlyAvailableTechnicians &&
        dateRange == null;
  }
}