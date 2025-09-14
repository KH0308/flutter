import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/calendar_models.dart';
import 'calendar_state.dart';
import '../utils/calendar_mock_data.dart';

/// Cubit for managing calendar state and business logic
class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState(selectedDate: DateTime.now())) {
    loadInitialData();
  }

  /// Load initial calendar data
  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockData = CalendarMockData.generateMockData();
      
      emit(state.copyWith(
        technicians: mockData['technicians'] as List<Technician>,
        events: mockData['events'] as List<CalendarEvent>,
        waitlist: mockData['waitlist'] as List<WaitlistEntry>,
        availableFloors: mockData['floors'] as List<String>,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load calendar data: ${e.toString()}',
      ));
    }
  }

  /// Select a new date
  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  /// Update calendar filters
  void updateFilters(CalendarFilters filters) {
    emit(state.copyWith(filters: filters));
  }

  /// Add floor filter
  void addFloorFilter(String floor) {
    final currentFloors = List<String>.from(state.filters.selectedFloors);
    if (!currentFloors.contains(floor)) {
      currentFloors.add(floor);
      final updatedFilters = state.filters.copyWith(selectedFloors: currentFloors);
      emit(state.copyWith(filters: updatedFilters));
    }
  }

  /// Remove floor filter
  void removeFloorFilter(String floor) {
    final currentFloors = List<String>.from(state.filters.selectedFloors);
    currentFloors.remove(floor);
    final updatedFilters = state.filters.copyWith(selectedFloors: currentFloors);
    emit(state.copyWith(filters: updatedFilters));
  }

  /// Toggle service type filter
  void toggleServiceTypeFilter(ServiceType serviceType) {
    final currentTypes = List<ServiceType>.from(state.filters.selectedServiceTypes);
    if (currentTypes.contains(serviceType)) {
      currentTypes.remove(serviceType);
    } else {
      currentTypes.add(serviceType);
    }
    final updatedFilters = state.filters.copyWith(selectedServiceTypes: currentTypes);
    emit(state.copyWith(filters: updatedFilters));
  }

  /// Toggle job status filter
  void toggleJobStatusFilter(JobStatus status) {
    final currentStatuses = List<JobStatus>.from(state.filters.selectedJobStatuses);
    if (currentStatuses.contains(status)) {
      currentStatuses.remove(status);
    } else {
      currentStatuses.add(status);
    }
    final updatedFilters = state.filters.copyWith(selectedJobStatuses: currentStatuses);
    emit(state.copyWith(filters: updatedFilters));
  }

  /// Toggle availability filter
  void toggleAvailabilityFilter() {
    final updatedFilters = state.filters.copyWith(
      showOnlyAvailableTechnicians: !state.filters.showOnlyAvailableTechnicians,
    );
    emit(state.copyWith(filters: updatedFilters));
  }

  /// Clear all filters
  void clearAllFilters() {
    emit(state.copyWith(filters: const CalendarFilters()));
  }

  /// Create a new event
  Future<void> createEvent(CalendarEvent event) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Check for conflicts
      final conflicts = state.events.where((e) => e.conflictsWith(event)).toList();
      if (conflicts.isNotEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Event conflicts with existing appointments',
        ));
        return;
      }
      
      final updatedEvents = List<CalendarEvent>.from(state.events);
      updatedEvents.add(event);
      
      emit(state.copyWith(
        events: updatedEvents,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create event: ${e.toString()}',
      ));
    }
  }

  /// Update an existing event
  Future<void> updateEvent(CalendarEvent updatedEvent) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      final updatedEvents = state.events.map((event) {
        return event.id == updatedEvent.id ? updatedEvent : event;
      }).toList();
      
      emit(state.copyWith(
        events: updatedEvents,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update event: ${e.toString()}',
      ));
    }
  }

  /// Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      final updatedEvents = state.events.where((event) => event.id != eventId).toList();
      
      emit(state.copyWith(
        events: updatedEvents,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete event: ${e.toString()}',
      ));
    }
  }

  /// Move event to different technician/time
  Future<void> moveEvent(String eventId, String newTechnicianId, DateTime newStartTime) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Find the event
      final event = state.events.firstWhere((e) => e.id == eventId);
      final duration = event.endTime.difference(event.startTime);
      final newEndTime = newStartTime.add(duration);
      
      final updatedEvent = event.copyWith(
        technicianId: newTechnicianId,
        startTime: newStartTime,
        endTime: newEndTime,
      );
      
      // Check for conflicts
      final conflicts = state.events
          .where((e) => e.id != eventId && e.conflictsWith(updatedEvent))
          .toList();
      
      if (conflicts.isNotEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Cannot move event: time slot conflicts with existing appointment',
        ));
        return;
      }
      
      await updateEvent(updatedEvent);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to move event: ${e.toString()}',
      ));
    }
  }

  /// Approve an event
  Future<void> approveEvent(String eventId) async {
    try {
      final event = state.events.firstWhere((e) => e.id == eventId);
      final updatedEvent = event.copyWith(isApproved: true);
      await updateEvent(updatedEvent);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to approve event: ${e.toString()}',
      ));
    }
  }

  /// Reject an event
  Future<void> rejectEvent(String eventId) async {
    try {
      final event = state.events.firstWhere((e) => e.id == eventId);
      final updatedEvent = event.copyWith(
        status: JobStatus.cancelled,
        isApproved: false,
      );
      await updateEvent(updatedEvent);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to reject event: ${e.toString()}',
      ));
    }
  }

  /// Add item to waitlist
  Future<void> addToWaitlist(WaitlistEntry entry) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      final updatedWaitlist = List<WaitlistEntry>.from(state.waitlist);
      updatedWaitlist.add(entry);
      
      // Sort by priority and requested date
      updatedWaitlist.sort((a, b) {
        final priorityComparison = b.priority.compareTo(a.priority);
        if (priorityComparison != 0) return priorityComparison;
        return a.requestedDate.compareTo(b.requestedDate);
      });
      
      emit(state.copyWith(
        waitlist: updatedWaitlist,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add to waitlist: ${e.toString()}',
      ));
    }
  }

  /// Remove item from waitlist
  Future<void> removeFromWaitlist(String entryId) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      final updatedWaitlist = state.waitlist.where((entry) => entry.id != entryId).toList();
      
      emit(state.copyWith(
        waitlist: updatedWaitlist,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to remove from waitlist: ${e.toString()}',
      ));
    }
  }

  /// Update technician availability
  Future<void> updateTechnicianAvailability(String technicianId, bool isAvailable) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      final updatedTechnicians = state.technicians.map((tech) {
        return tech.id == technicianId 
            ? tech.copyWith(isAvailable: isAvailable) 
            : tech;
      }).toList();
      
      emit(state.copyWith(
        technicians: updatedTechnicians,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update technician availability: ${e.toString()}',
      ));
    }
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}