import 'package:equatable/equatable.dart';
import '../models/calendar_models.dart';

/// Represents the state of the calendar
class CalendarState extends Equatable {
  final List<Technician> technicians;
  final List<CalendarEvent> events;
  final List<WaitlistEntry> waitlist;
  final DateTime selectedDate;
  final CalendarFilters filters;
  final bool isLoading;
  final String? errorMessage;
  final List<String> availableFloors;

  const CalendarState({
    this.technicians = const [],
    this.events = const [],
    this.waitlist = const [],
    required this.selectedDate,
    this.filters = const CalendarFilters(),
    this.isLoading = false,
    this.errorMessage,
    this.availableFloors = const [],
  });

  @override
  List<Object?> get props => [
        technicians,
        events,
        waitlist,
        selectedDate,
        filters,
        isLoading,
        errorMessage,
        availableFloors,
      ];

  CalendarState copyWith({
    List<Technician>? technicians,
    List<CalendarEvent>? events,
    List<WaitlistEntry>? waitlist,
    DateTime? selectedDate,
    CalendarFilters? filters,
    bool? isLoading,
    String? errorMessage,
    List<String>? availableFloors,
  }) {
    return CalendarState(
      technicians: technicians ?? this.technicians,
      events: events ?? this.events,
      waitlist: waitlist ?? this.waitlist,
      selectedDate: selectedDate ?? this.selectedDate,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      availableFloors: availableFloors ?? this.availableFloors,
    );
  }

  /// Get filtered technicians based on current filters
  List<Technician> get filteredTechnicians {
    return technicians.where((tech) {
      // Filter by floor
      if (filters.selectedFloors.isNotEmpty && 
          !filters.selectedFloors.contains(tech.floor)) {
        return false;
      }

      // Filter by availability
      if (filters.showOnlyAvailableTechnicians && !tech.isAvailable) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get filtered events based on current filters and selected date
  List<CalendarEvent> get filteredEvents {
    return events.where((event) {
      // Filter by date
      final eventDate = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      final selectedDateOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      
      if (!eventDate.isAtSameMomentAs(selectedDateOnly)) {
        return false;
      }

      // Filter by service type
      if (filters.selectedServiceTypes.isNotEmpty && 
          !filters.selectedServiceTypes.contains(event.serviceType)) {
        return false;
      }

      // Filter by job status
      if (filters.selectedJobStatuses.isNotEmpty && 
          !filters.selectedJobStatuses.contains(event.status)) {
        return false;
      }

      // Filter by technician (if technician is filtered out, hide their events)
      final technicianExists = filteredTechnicians
          .any((tech) => tech.id == event.technicianId);
      if (!technicianExists) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get events for a specific technician on the selected date
  List<CalendarEvent> getEventsForTechnician(String technicianId) {
    return filteredEvents
        .where((event) => event.technicianId == technicianId)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Get events that require approval
  List<CalendarEvent> get eventsRequiringApproval {
    return events
        .where((event) => event.requiresApproval && !event.isApproved)
        .toList();
  }

  /// Check if a technician has any conflicts on selected date
  bool technicianHasConflicts(String technicianId) {
    final techEvents = getEventsForTechnician(technicianId);
    for (int i = 0; i < techEvents.length; i++) {
      for (int j = i + 1; j < techEvents.length; j++) {
        if (techEvents[i].conflictsWith(techEvents[j])) {
          return true;
        }
      }
    }
    return false;
  }

  /// Get total working hours for a technician on selected date
  double getTechnicianWorkingHours(String technicianId) {
    return getEventsForTechnician(technicianId)
        .fold(0.0, (sum, event) => sum + event.durationInHours);
  }

  /// Check if the calendar has any data
  bool get hasData {
    return technicians.isNotEmpty || events.isNotEmpty || waitlist.isNotEmpty;
  }

  /// Get availability status summary
  Map<String, int> get availabilitySummary {
    final available = technicians.where((t) => t.isAvailable).length;
    final unavailable = technicians.length - available;
    return {
      'available': available,
      'unavailable': unavailable,
      'total': technicians.length,
    };
  }
}