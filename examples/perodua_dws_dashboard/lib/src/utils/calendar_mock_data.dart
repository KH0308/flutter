import '../models/calendar_models.dart';

/// Utility class for generating mock data for the calendar dashboard
class CalendarMockData {
  static Map<String, dynamic> generateMockData() {
    final technicians = _generateTechnicians();
    final events = _generateEvents(technicians);
    final waitlist = _generateWaitlist();
    final floors = _getAvailableFloors(technicians);

    return {
      'technicians': technicians,
      'events': events,
      'waitlist': waitlist,
      'floors': floors,
    };
  }

  static List<Technician> _generateTechnicians() {
    return [
      const Technician(
        id: 'tech_001',
        name: 'Ahmad Rahman',
        floor: 'Ground Floor',
        isAvailable: true,
        specialization: 'Engine Maintenance',
      ),
      const Technician(
        id: 'tech_002',
        name: 'Siti Nurhaliza',
        floor: 'Ground Floor',
        isAvailable: true,
        specialization: 'Electrical Systems',
      ),
      const Technician(
        id: 'tech_003',
        name: 'Lim Wei Ming',
        floor: 'First Floor',
        isAvailable: false,
        specialization: 'Body Repair',
      ),
      const Technician(
        id: 'tech_004',
        name: 'Priya Sharma',
        floor: 'First Floor',
        isAvailable: true,
        specialization: 'Transmission',
      ),
      const Technician(
        id: 'tech_005',
        name: 'Muhammad Faiz',
        floor: 'Second Floor',
        isAvailable: true,
        specialization: 'Air Conditioning',
      ),
      const Technician(
        id: 'tech_006',
        name: 'Chen Li Hua',
        floor: 'Second Floor',
        isAvailable: true,
        specialization: 'Brake Systems',
      ),
      const Technician(
        id: 'tech_007',
        name: 'Raj Kumar',
        floor: 'Ground Floor',
        isAvailable: false,
        specialization: 'General Maintenance',
      ),
      const Technician(
        id: 'tech_008',
        name: 'Nurul Aisyah',
        floor: 'First Floor',
        isAvailable: true,
        specialization: 'Diagnostic Systems',
      ),
    ];
  }

  static List<CalendarEvent> _generateEvents(List<Technician> technicians) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      // Today's events
      CalendarEvent(
        id: 'event_001',
        title: 'Engine Oil Change',
        description: 'Regular maintenance service for Perodua Myvi',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 10, minutes: 30)),
        technicianId: 'tech_001',
        serviceType: ServiceType.maintenance,
        status: JobStatus.inProgress,
        customerName: 'John Doe',
        vehicleInfo: 'Perodua Myvi 2020 - ABC123',
        requiresApproval: false,
        isApproved: true,
      ),
      CalendarEvent(
        id: 'event_002',
        title: 'Brake Inspection',
        description: 'Annual brake system inspection',
        startTime: today.add(const Duration(hours: 10)),
        endTime: today.add(const Duration(hours: 11, minutes: 30)),
        technicianId: 'tech_006',
        serviceType: ServiceType.inspection,
        status: JobStatus.pending,
        customerName: 'Mary Smith',
        vehicleInfo: 'Perodua Axia 2019 - XYZ789',
        requiresApproval: true,
        isApproved: false,
      ),
      CalendarEvent(
        id: 'event_003',
        title: 'Air Con Service',
        description: 'AC system cleaning and gas refill',
        startTime: today.add(const Duration(hours: 11)),
        endTime: today.add(const Duration(hours: 12, minutes: 30)),
        technicianId: 'tech_005',
        serviceType: ServiceType.maintenance,
        status: JobStatus.completed,
        customerName: 'Ali Hassan',
        vehicleInfo: 'Perodua Bezza 2021 - DEF456',
        requiresApproval: false,
        isApproved: true,
      ),
      CalendarEvent(
        id: 'event_004',
        title: 'Transmission Repair',
        description: 'Automatic transmission diagnostic and repair',
        startTime: today.add(const Duration(hours: 14)),
        endTime: today.add(const Duration(hours: 16)),
        technicianId: 'tech_004',
        serviceType: ServiceType.repair,
        status: JobStatus.inProgress,
        customerName: 'Sarah Johnson',
        vehicleInfo: 'Perodua Aruz 2020 - GHI789',
        requiresApproval: true,
        isApproved: true,
      ),
      CalendarEvent(
        id: 'event_005',
        title: 'Electrical Check',
        description: 'Battery and alternator testing',
        startTime: today.add(const Duration(hours: 15)),
        endTime: today.add(const Duration(hours: 16)),
        technicianId: 'tech_002',
        serviceType: ServiceType.inspection,
        status: JobStatus.pending,
        customerName: 'Robert Lee',
        vehicleInfo: 'Perodua Alza 2018 - JKL012',
        requiresApproval: false,
        isApproved: true,
      ),
      CalendarEvent(
        id: 'event_006',
        title: 'Emergency Brake Fix',
        description: 'Urgent brake pad replacement',
        startTime: today.add(const Duration(hours: 16, minutes: 30)),
        endTime: today.add(const Duration(hours: 17, minutes: 30)),
        technicianId: 'tech_006',
        serviceType: ServiceType.emergency,
        status: JobStatus.waitingApproval,
        customerName: 'Emergency Customer',
        vehicleInfo: 'Perodua Viva 2015 - EMG999',
        requiresApproval: true,
        isApproved: false,
      ),

      // Tomorrow's events
      CalendarEvent(
        id: 'event_007',
        title: 'Full Service',
        description: 'Complete vehicle inspection and maintenance',
        startTime: today.add(const Duration(days: 1, hours: 8)),
        endTime: today.add(const Duration(days: 1, hours: 12)),
        technicianId: 'tech_001',
        serviceType: ServiceType.maintenance,
        status: JobStatus.pending,
        customerName: 'David Wong',
        vehicleInfo: 'Perodua Myvi 2022 - FUT123',
        requiresApproval: false,
        isApproved: true,
      ),
      CalendarEvent(
        id: 'event_008',
        title: 'Paint Touch-up',
        description: 'Minor scratch repair and paint touch-up',
        startTime: today.add(const Duration(days: 1, hours: 9)),
        endTime: today.add(const Duration(days: 1, hours: 11)),
        technicianId: 'tech_003',
        serviceType: ServiceType.repair,
        status: JobStatus.pending,
        customerName: 'Linda Tan',
        vehicleInfo: 'Perodua Axia 2021 - PNT456',
        requiresApproval: true,
        isApproved: false,
      ),

      // Yesterday's events (for reference)
      CalendarEvent(
        id: 'event_009',
        title: 'Oil Change',
        description: 'Routine oil change service',
        startTime: today.subtract(const Duration(days: 1, hours: -10)),
        endTime: today.subtract(const Duration(days: 1, hours: -11)),
        technicianId: 'tech_001',
        serviceType: ServiceType.maintenance,
        status: JobStatus.completed,
        customerName: 'Past Customer',
        vehicleInfo: 'Perodua Bezza 2019 - OLD123',
        requiresApproval: false,
        isApproved: true,
      ),
    ];
  }

  static List<WaitlistEntry> _generateWaitlist() {
    final now = DateTime.now();
    
    return [
      WaitlistEntry(
        id: 'wait_001',
        customerName: 'Jennifer Lim',
        vehicleInfo: 'Perodua Myvi 2020 - WAIT01',
        serviceType: ServiceType.maintenance,
        description: 'Regular 10,000km service',
        requestedDate: now.add(const Duration(days: 1)),
        priority: 2,
      ),
      WaitlistEntry(
        id: 'wait_002',
        customerName: 'Michael Chen',
        vehicleInfo: 'Perodua Axia 2019 - WAIT02',
        serviceType: ServiceType.repair,
        description: 'Strange noise from engine compartment',
        requestedDate: now,
        priority: 3,
      ),
      WaitlistEntry(
        id: 'wait_003',
        customerName: 'Susan Kumar',
        vehicleInfo: 'Perodua Alza 2021 - WAIT03',
        serviceType: ServiceType.inspection,
        description: 'Pre-purchase inspection',
        requestedDate: now.add(const Duration(days: 2)),
        priority: 1,
      ),
      WaitlistEntry(
        id: 'wait_004',
        customerName: 'Emergency Client',
        vehicleInfo: 'Perodua Bezza 2018 - EMRG01',
        serviceType: ServiceType.emergency,
        description: 'Car won\'t start - battery issues',
        requestedDate: now,
        priority: 5,
      ),
    ];
  }

  static List<String> _getAvailableFloors(List<Technician> technicians) {
    return technicians
        .map((tech) => tech.floor)
        .toSet()
        .toList()
      ..sort();
  }

  /// Generate additional events for testing different scenarios
  static List<CalendarEvent> generateConflictingEvents(List<Technician> technicians) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      CalendarEvent(
        id: 'conflict_001',
        title: 'Conflicting Service 1',
        description: 'This event conflicts with another',
        startTime: today.add(const Duration(hours: 9, minutes: 30)),
        endTime: today.add(const Duration(hours: 10, minutes: 30)),
        technicianId: 'tech_001',
        serviceType: ServiceType.maintenance,
        status: JobStatus.pending,
        customerName: 'Conflict Customer 1',
        vehicleInfo: 'Test Vehicle 1',
      ),
      CalendarEvent(
        id: 'conflict_002',
        title: 'Conflicting Service 2',
        description: 'This event also conflicts',
        startTime: today.add(const Duration(hours: 10)),
        endTime: today.add(const Duration(hours: 11)),
        technicianId: 'tech_001',
        serviceType: ServiceType.repair,
        status: JobStatus.pending,
        customerName: 'Conflict Customer 2',
        vehicleInfo: 'Test Vehicle 2',
      ),
    ];
  }

  /// Generate events for load testing
  static List<CalendarEvent> generateLargeDataSet(List<Technician> technicians, {int eventCount = 100}) {
    final events = <CalendarEvent>[];
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    
    for (int i = 0; i < eventCount; i++) {
      final dayOffset = (random + i) % 7 - 3; // Events from 3 days ago to 3 days in future
      final hourOffset = (random + i * 2) % 10 + 8; // Between 8 AM and 6 PM
      final duration = ((random + i * 3) % 4 + 1) * 30; // 30 min to 2 hours
      
      final startTime = DateTime(now.year, now.month, now.day + dayOffset, hourOffset);
      
      events.add(CalendarEvent(
        id: 'load_test_${i.toString().padLeft(3, '0')}',
        title: 'Service ${i + 1}',
        description: 'Generated test service #${i + 1}',
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: duration)),
        technicianId: technicians[(random + i) % technicians.length].id,
        serviceType: ServiceType.values[(random + i) % ServiceType.values.length],
        status: JobStatus.values[(random + i) % JobStatus.values.length],
        customerName: 'Test Customer ${i + 1}',
        vehicleInfo: 'Test Vehicle ${i + 1}',
        requiresApproval: (random + i) % 3 == 0,
        isApproved: (random + i) % 2 == 0,
      ));
    }
    
    return events;
  }
}