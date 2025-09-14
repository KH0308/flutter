import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/calendar_cubit.dart';
import '../models/calendar_models.dart';

class EventCard extends StatelessWidget {
  final CalendarEvent event;
  final bool isBeingDragged;

  const EventCard({
    super.key,
    required this.event,
    this.isBeingDragged = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: _getEventColor(),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
        boxShadow: isBeingDragged
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: InkWell(
        onTap: () => _showEventDetails(context),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with time and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getTextColor(),
                      ),
                    ),
                  ),
                  if (event.requiresApproval && !event.isApproved)
                    Icon(
                      Icons.pending_actions,
                      size: 12,
                      color: _getTextColor(),
                    ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 12,
                      color: _getTextColor(),
                    ),
                    iconSize: 12,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      if (event.requiresApproval && !event.isApproved) ...[
                        const PopupMenuItem(
                          value: 'approve',
                          child: Row(
                            children: [
                              Icon(Icons.check, size: 16, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Approve'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reject',
                          child: Row(
                            children: [
                              Icon(Icons.close, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Reject'),
                            ],
                          ),
                        ),
                      ],
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) => _handleMenuAction(context, value),
                  ),
                ],
              ),
              // Title
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Customer info
              if (event.customerName != null)
                Text(
                  event.customerName!,
                  style: TextStyle(
                    fontSize: 10,
                    color: _getTextColor().withOpacity(0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getEventColor() {
    if (event.status == JobStatus.cancelled) {
      return const Color(0xFFFEE2E2); // Light red
    }
    
    switch (event.serviceType) {
      case ServiceType.maintenance:
        return const Color(0xFFDCFDF7); // Light green
      case ServiceType.repair:
        return const Color(0xFFDFE9FF); // Light blue
      case ServiceType.inspection:
        return const Color(0xFFFEF3C7); // Light yellow
      case ServiceType.installation:
        return const Color(0xFFF3E8FF); // Light purple
      case ServiceType.emergency:
        return const Color(0xFFFEF2F2); // Light red
    }
  }

  Color _getBorderColor() {
    if (event.status == JobStatus.cancelled) {
      return const Color(0xFFDC2626); // Red
    }
    
    if (event.requiresApproval && !event.isApproved) {
      return const Color(0xFFF59E0B); // Orange
    }
    
    switch (event.serviceType) {
      case ServiceType.maintenance:
        return const Color(0xFF10B981); // Green
      case ServiceType.repair:
        return const Color(0xFF3B82F6); // Blue
      case ServiceType.inspection:
        return const Color(0xFFF59E0B); // Yellow
      case ServiceType.installation:
        return const Color(0xFF8B5CF6); // Purple
      case ServiceType.emergency:
        return const Color(0xFFDC2626); // Red
    }
  }

  Color _getTextColor() {
    if (event.status == JobStatus.cancelled) {
      return const Color(0xFF7F1D1D); // Dark red
    }
    
    switch (event.serviceType) {
      case ServiceType.maintenance:
        return const Color(0xFF064E3B); // Dark green
      case ServiceType.repair:
        return const Color(0xFF1E3A8A); // Dark blue
      case ServiceType.inspection:
        return const Color(0xFF92400E); // Dark yellow
      case ServiceType.installation:
        return const Color(0xFF581C87); // Dark purple
      case ServiceType.emergency:
        return const Color(0xFF7F1D1D); // Dark red
    }
  }

  void _showEventDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EventDetailsDialog(event: event),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    final cubit = context.read<CalendarCubit>();
    
    switch (action) {
      case 'edit':
        _showEditDialog(context);
        break;
      case 'approve':
        cubit.approveEvent(event.id);
        break;
      case 'reject':
        cubit.rejectEvent(event.id);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showEditDialog(BuildContext context) {
    // TODO: Implement edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality not yet implemented')),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CalendarCubit>().deleteEvent(event.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EventDetailsDialog extends StatelessWidget {
  final CalendarEvent event;

  const _EventDetailsDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Time
            _buildDetailRow(
              Icons.schedule,
              'Time',
              '${DateFormat('MMM dd, yyyy • HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
            ),
            
            // Service Type
            _buildDetailRow(
              Icons.build,
              'Service Type',
              _getServiceTypeLabel(event.serviceType),
            ),
            
            // Status
            _buildDetailRow(
              Icons.info,
              'Status',
              _getJobStatusLabel(event.status),
            ),
            
            // Customer
            if (event.customerName != null)
              _buildDetailRow(
                Icons.person,
                'Customer',
                event.customerName!,
              ),
            
            // Vehicle
            if (event.vehicleInfo != null)
              _buildDetailRow(
                Icons.directions_car,
                'Vehicle',
                event.vehicleInfo!,
              ),
            
            // Description
            _buildDetailRow(
              Icons.description,
              'Description',
              event.description,
            ),
            
            // Approval status
            if (event.requiresApproval)
              _buildDetailRow(
                Icons.approval,
                'Approval',
                event.isApproved ? 'Approved' : 'Pending Approval',
              ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            if (event.requiresApproval && !event.isApproved)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<CalendarCubit>().rejectEvent(event.id);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text('Reject', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<CalendarCubit>().approveEvent(event.id);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}