import 'package:flutter_test/flutter_test.dart';
import 'package:perodua_dws_dashboard/src/models/calendar_models.dart';
import 'package:perodua_dws_dashboard/src/utils/calendar_mock_data.dart';

void main() {
  group('Calendar Models Tests', () {
    test('Technician model should be created correctly', () {
      const technician = Technician(
        id: 'test_001',
        name: 'Test Technician',
        floor: 'Ground Floor',
        isAvailable: true,
        specialization: 'Engine Maintenance',
      );

      expect(technician.id, 'test_001');
      expect(technician.name, 'Test Technician');
      expect(technician.floor, 'Ground Floor');
      expect(technician.isAvailable, true);
      expect(technician.specialization, 'Engine Maintenance');
    });

    test('CalendarEvent model should calculate duration correctly', () {
      final startTime = DateTime(2024, 1, 1, 9, 0);
      final endTime = DateTime(2024, 1, 1, 11, 30);
      
      final event = CalendarEvent(
        id: 'test_event',
        title: 'Test Service',
        description: 'Test description',
        startTime: startTime,
        endTime: endTime,
        technicianId: 'tech_001',
        serviceType: ServiceType.maintenance,
        status: JobStatus.pending,
      );

      expect(event.durationInHours, 2.5);
    });

    test('CalendarEvent should detect conflicts correctly', () {
      final baseTime = DateTime(2024, 1, 1, 9, 0);
      
      final event1 = CalendarEvent(
        id: 'event_1',
        title: 'Service 1',
        description: 'Description 1',
        startTime: baseTime,
        endTime: baseTime.add(const Duration(hours: 2)),
        technicianId: 'tech_001',
        serviceType: ServiceType.maintenance,
        status: JobStatus.pending,
      );

      final event2 = CalendarEvent(
        id: 'event_2',
        title: 'Service 2',
        description: 'Description 2',
        startTime: baseTime.add(const Duration(hours: 1)),
        endTime: baseTime.add(const Duration(hours: 3)),
        technicianId: 'tech_001',
        serviceType: ServiceType.repair,
        status: JobStatus.pending,
      );

      final event3 = CalendarEvent(
        id: 'event_3',
        title: 'Service 3',
        description: 'Description 3',
        startTime: baseTime.add(const Duration(hours: 3)),
        endTime: baseTime.add(const Duration(hours: 4)),
        technicianId: 'tech_001',
        serviceType: ServiceType.inspection,
        status: JobStatus.pending,
      );

      // event1 and event2 should conflict (same technician, overlapping time)
      expect(event1.conflictsWith(event2), true);
      expect(event2.conflictsWith(event1), true);

      // event1 and event3 should not conflict (same technician, no time overlap)
      expect(event1.conflictsWith(event3), false);
      expect(event3.conflictsWith(event1), false);
    });

    test('CalendarFilters should detect empty state correctly', () {
      const emptyFilters = CalendarFilters();
      expect(emptyFilters.isEmpty, true);

      const filtersWithFloor = CalendarFilters(
        selectedFloors: ['Ground Floor'],
      );
      expect(filtersWithFloor.isEmpty, false);

      const filtersWithServiceType = CalendarFilters(
        selectedServiceTypes: [ServiceType.maintenance],
      );
      expect(filtersWithServiceType.isEmpty, false);
    });
  });

  group('Calendar Mock Data Tests', () {
    test('Should generate mock data with all required fields', () {
      final mockData = CalendarMockData.generateMockData();

      expect(mockData.containsKey('technicians'), true);
      expect(mockData.containsKey('events'), true);
      expect(mockData.containsKey('waitlist'), true);
      expect(mockData.containsKey('floors'), true);

      final technicians = mockData['technicians'] as List<Technician>;
      final events = mockData['events'] as List<CalendarEvent>;
      final waitlist = mockData['waitlist'] as List<WaitlistEntry>;
      final floors = mockData['floors'] as List<String>;

      expect(technicians.isNotEmpty, true);
      expect(events.isNotEmpty, true);
      expect(waitlist.isNotEmpty, true);
      expect(floors.isNotEmpty, true);

      // Check that all technicians have valid data
      for (final tech in technicians) {
        expect(tech.id.isNotEmpty, true);
        expect(tech.name.isNotEmpty, true);
        expect(tech.floor.isNotEmpty, true);
      }

      // Check that all events have valid technician IDs
      final technicianIds = technicians.map((t) => t.id).toSet();
      for (final event in events) {
        expect(technicianIds.contains(event.technicianId), true);
      }
    });

    test('Should generate floors from technicians correctly', () {
      final mockData = CalendarMockData.generateMockData();
      final technicians = mockData['technicians'] as List<Technician>;
      final floors = mockData['floors'] as List<String>;

      final expectedFloors = technicians.map((t) => t.floor).toSet().toList()..sort();
      
      expect(floors.length, expectedFloors.length);
      for (int i = 0; i < floors.length; i++) {
        expect(floors[i], expectedFloors[i]);
      }
    });
  });
}