import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/calendar_cubit.dart';
import '../models/calendar_models.dart';
import 'event_card.dart';

class TechnicianLane extends StatelessWidget {
  final Technician technician;
  final List<CalendarEvent> events;
  final bool hasConflicts;
  final double workingHours;

  const TechnicianLane({
    super.key,
    required this.technician,
    required this.events,
    required this.hasConflicts,
    required this.workingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Technician info section
          _buildTechnicianInfo(),
          // Timeline section
          Expanded(
            child: _buildTimeline(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianInfo() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: technician.isAvailable 
                  ? const Color(0xFF10B981) 
                  : const Color(0xFFF59E0B),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                technician.name.split(' ').map((name) => name[0]).take(2).join(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Technician details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  technician.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  technician.floor,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                if (technician.specialization != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    technician.specialization!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Status indicators
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasConflicts)
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Colors.red.shade600,
                ),
              if (workingHours > 8)
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.orange.shade600,
                ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: technician.isAvailable 
                      ? const Color(0xFF10B981) 
                      : const Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Container(
      height: 80,
      child: DragTarget<CalendarEvent>(
        onAcceptWithDetails: (details) {
          _handleEventDrop(context, details.data);
        },
        builder: (context, candidateData, rejectedData) {
          return Stack(
            children: [
              // Time grid background
              _buildTimeGrid(),
              // Events
              ...events.map((event) => _buildEventOnTimeline(context, event)),
              // Drop indicator
              if (candidateData.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFF2563EB),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid() {
    return Row(
      children: List.generate(12, (index) {
        return Container(
          width: 80,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEventOnTimeline(BuildContext context, CalendarEvent event) {
    // Calculate position and width based on time
    final startHour = event.startTime.hour;
    final startMinute = event.startTime.minute;
    final endHour = event.endTime.hour;
    final endMinute = event.endTime.minute;
    
    // Timeline starts at 8 AM
    final startOffset = ((startHour - 8) * 60 + startMinute) / 60.0;
    final duration = ((endHour - 8) * 60 + endMinute - (startHour - 8) * 60 - startMinute) / 60.0;
    
    final left = startOffset * 80.0; // 80px per hour
    final width = duration * 80.0;
    
    return Positioned(
      left: left,
      top: 8,
      child: Draggable<CalendarEvent>(
        data: event,
        feedback: Material(
          child: SizedBox(
            width: width,
            child: EventCard(
              event: event,
              isBeingDragged: true,
            ),
          ),
        ),
        childWhenDragging: Container(
          width: width,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.dashed,
            ),
          ),
        ),
        child: SizedBox(
          width: width,
          child: EventCard(event: event),
        ),
      ),
    );
  }

  void _handleEventDrop(BuildContext context, CalendarEvent event) {
    // Calculate new start time based on drop position
    // For now, we'll use the original time but assign to this technician
    context.read<CalendarCubit>().moveEvent(
      event.id,
      technician.id,
      event.startTime,
    );
  }
}