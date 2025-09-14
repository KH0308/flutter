import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../models/calendar_models.dart';

class CalendarSidebar extends StatelessWidget {
  const CalendarSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalendarDatePicker(context, state),
                const SizedBox(height: 24),
                _buildAvailabilitySection(context, state),
                const SizedBox(height: 24),
                _buildWaitListSection(context, state),
                const SizedBox(height: 24),
                _buildFiltersSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarDatePicker(BuildContext context, CalendarState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calendar Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _showDatePicker(context, state),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(state.selectedDate),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context, CalendarState state) {
    final summary = state.availabilitySummary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Availability',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildAvailabilityRow('Available', summary['available']!, const Color(0xFF10B981)),
              const SizedBox(height: 8),
              _buildAvailabilityRow('Unavailable', summary['unavailable']!, const Color(0xFFF59E0B)),
              const SizedBox(height: 8),
              _buildAvailabilityRow('Total', summary['total']!, const Color(0xFF6B7280)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityRow(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildWaitListSection(BuildContext context, CalendarState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Wait List',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                state.waitlist.length.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: state.waitlist.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = state.waitlist[index];
              return _buildWaitListItem(context, entry);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWaitListItem(BuildContext context, WaitlistEntry entry) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.customerName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(entry.priority),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'P${entry.priority}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            entry.vehicleInfo,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF92400E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.description,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF78350F),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(BuildContext context, CalendarState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            if (!state.filters.isEmpty)
              TextButton(
                onPressed: () => context.read<CalendarCubit>().clearAllFilters(),
                child: const Text(
                  'Clear All',
                  style: TextStyle(fontSize: 12, color: Color(0xFFF59E0B)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFloorFilters(context, state),
        const SizedBox(height: 16),
        _buildServiceTypeFilters(context, state),
        const SizedBox(height: 16),
        _buildJobStatusFilters(context, state),
        const SizedBox(height: 16),
        _buildAvailabilityFilter(context, state),
      ],
    );
  }

  Widget _buildFloorFilters(BuildContext context, CalendarState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Floor',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.availableFloors.map((floor) {
            final isSelected = state.filters.selectedFloors.contains(floor);
            return InkWell(
              onTap: () {
                if (isSelected) {
                  context.read<CalendarCubit>().removeFloorFilter(floor);
                } else {
                  context.read<CalendarCubit>().addFloorFilter(floor);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  floor,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceTypeFilters(BuildContext context, CalendarState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ServiceType.values.map((type) {
            final isSelected = state.filters.selectedServiceTypes.contains(type);
            return InkWell(
              onTap: () => context.read<CalendarCubit>().toggleServiceTypeFilter(type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getServiceTypeLabel(type),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildJobStatusFilters(BuildContext context, CalendarState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Status',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: JobStatus.values.map((status) {
            final isSelected = state.filters.selectedJobStatuses.contains(status);
            return InkWell(
              onTap: () => context.read<CalendarCubit>().toggleJobStatusFilter(status),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? _getJobStatusColor(status) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? _getJobStatusColor(status) : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getJobStatusLabel(status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilityFilter(BuildContext context, CalendarState state) {
    return Row(
      children: [
        Checkbox(
          value: state.filters.showOnlyAvailableTechnicians,
          onChanged: (value) => context.read<CalendarCubit>().toggleAvailabilityFilter(),
          activeColor: const Color(0xFF2563EB),
        ),
        const Expanded(
          child: Text(
            'Show only available technicians',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context, CalendarState state) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      context.read<CalendarCubit>().selectDate(selectedDate);
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 5:
        return const Color(0xFFDC2626); // Red for highest priority
      case 4:
        return const Color(0xFFF59E0B); // Orange
      case 3:
        return const Color(0xFF10B981); // Green
      case 2:
        return const Color(0xFF3B82F6); // Blue
      default:
        return const Color(0xFF6B7280); // Gray for lowest priority
    }
  }

  String _getServiceTypeLabel(ServiceType type) {
    switch (type) {
      case ServiceType.maintenance:
        return 'Maintenance';
      case ServiceType.repair:
        return 'Repair';
      case ServiceType.inspection:
        return 'Inspection';
      case ServiceType.installation:
        return 'Installation';
      case ServiceType.emergency:
        return 'Emergency';
    }
  }

  String _getJobStatusLabel(JobStatus status) {
    switch (status) {
      case JobStatus.pending:
        return 'Pending';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.cancelled:
        return 'Cancelled';
      case JobStatus.waitingApproval:
        return 'Waiting Approval';
    }
  }

  Color _getJobStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.pending:
        return const Color(0xFF6B7280);
      case JobStatus.inProgress:
        return const Color(0xFF3B82F6);
      case JobStatus.completed:
        return const Color(0xFF10B981);
      case JobStatus.cancelled:
        return const Color(0xFFDC2626);
      case JobStatus.waitingApproval:
        return const Color(0xFFF59E0B);
    }
  }
}