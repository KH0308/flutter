import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../models/calendar_models.dart';
import 'calendar_sidebar.dart';
import 'technician_lane.dart';
import 'event_card.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () => context.read<CalendarCubit>().clearError(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && !state.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Row(
            children: [
              // Sidebar
              const SizedBox(
                width: 300,
                child: CalendarSidebar(),
              ),
              // Main calendar area
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(context, state),
                    Expanded(
                      child: _buildCalendarGrid(context, state),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CalendarState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date navigation
          IconButton(
            onPressed: () {
              final previousDay = state.selectedDate.subtract(const Duration(days: 1));
              context.read<CalendarCubit>().selectDate(previousDay);
            },
            icon: const Icon(Icons.chevron_left, color: Color(0xFF2563EB)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(state.selectedDate),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final nextDay = state.selectedDate.add(const Duration(days: 1));
              context.read<CalendarCubit>().selectDate(nextDay);
            },
            icon: const Icon(Icons.chevron_right, color: Color(0xFF2563EB)),
          ),
          const Spacer(),
          // Summary stats
          _buildSummaryCard(
            'Total Events',
            state.filteredEvents.length.toString(),
            Icons.event,
            const Color(0xFF10B981),
          ),
          const SizedBox(width: 16),
          _buildSummaryCard(
            'Available Techs',
            state.availabilitySummary['available'].toString(),
            Icons.person,
            const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 16),
          _buildSummaryCard(
            'Pending Approval',
            state.eventsRequiringApproval.length.toString(),
            Icons.pending_actions,
            const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, CalendarState state) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Time header
          _buildTimeHeader(),
          // Technician lanes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.filteredTechnicians.length,
              itemBuilder: (context, index) {
                final technician = state.filteredTechnicians[index];
                return TechnicianLane(
                  technician: technician,
                  events: state.getEventsForTechnician(technician.id),
                  hasConflicts: state.technicianHasConflicts(technician.id),
                  workingHours: state.getTechnicianWorkingHours(technician.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Technician column header
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Technician',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          // Time slots
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(12, (index) {
                  final hour = 8 + index; // 8 AM to 8 PM
                  return Container(
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}