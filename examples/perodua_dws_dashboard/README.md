# Perodua DWS Dashboard

A Flutter dashboard application for managing Perodua Service Center calendar, technician scheduling, and approval workflows.

## Features

### 📅 Calendar Management
- **Daily View**: Clean calendar interface showing technician lanes and time slots
- **Date Navigation**: Easy navigation between different dates
- **Real-time Updates**: Dynamic event display based on selected date

### 👥 Technician Management
- **Technician Lanes**: Visual representation of each technician's schedule
- **Availability Status**: Clear indicators for available/unavailable technicians
- **Floor-based Organization**: Technicians organized by service floor
- **Specialization Display**: Shows technician expertise areas

### 🎫 Event Management
- **Event Cards**: Color-coded cards showing service appointments
- **Drag & Drop**: Move events between technicians and time slots
- **Service Types**: Support for Maintenance, Repair, Inspection, Installation, Emergency
- **Job Status Tracking**: Pending, In Progress, Completed, Cancelled, Waiting Approval

### ✅ Approval Workflow
- **Approval Required**: Events can be marked as requiring approval
- **Quick Actions**: Approve or reject events directly from the calendar
- **Visual Indicators**: Clear markers for events awaiting approval

### 🔍 Filtering & Search
- **Floor Filters**: Filter technicians by service floor
- **Service Type Filters**: Show only specific types of services
- **Job Status Filters**: Filter by job completion status
- **Availability Filters**: Show only available technicians

### 📋 Waitlist Management
- **Priority Queue**: Waitlist entries with priority levels
- **Customer Information**: Track customer details and vehicle info
- **Service Requests**: Manage pending service requests

## Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (^3.0.0)

### Installation

1. Navigate to the dashboard directory:
   ```bash
   cd examples/perodua_dws_dashboard
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## Architecture

### State Management
- **BLoC Pattern**: Uses `flutter_bloc` for state management
- **CalendarCubit**: Manages all calendar-related state and business logic
- **CalendarState**: Immutable state containing technicians, events, and filters

### Data Models
- **Technician**: Represents service technicians with availability and specialization
- **CalendarEvent**: Service appointments with time, customer, and approval status
- **WaitlistEntry**: Pending service requests with priority
- **CalendarFilters**: Filter settings for the calendar view

### Key Components
- **CalendarView**: Main dashboard layout with sidebar and calendar grid
- **CalendarSidebar**: Date picker, filters, and waitlist management
- **TechnicianLane**: Individual technician timeline with events
- **EventCard**: Interactive event cards with drag-and-drop support

## Usage

### Viewing the Calendar
1. The main view shows today's date by default
2. Use the date navigation arrows or click the date to change days
3. Technician lanes are displayed vertically with time slots horizontally

### Managing Events
1. **View Details**: Click on any event card to see full details
2. **Move Events**: Drag event cards between technicians or time slots
3. **Approve/Reject**: Use the menu on event cards for approval actions
4. **Edit/Delete**: Access additional options through the event menu

### Filtering Data
1. **By Floor**: Select specific floors in the sidebar filter section
2. **By Service Type**: Toggle service types (Maintenance, Repair, etc.)
3. **By Status**: Filter events by their completion status
4. **By Availability**: Show only available technicians

### Managing Waitlist
1. View pending requests in the sidebar waitlist section
2. Priority levels are color-coded (P1-P5)
3. Customer and vehicle information is displayed for each entry

## Customization

### Colors and Themes
The app uses a consistent color scheme defined in the main theme:
- Primary Blue: `#2563EB`
- Success Green: `#10B981`
- Warning Orange: `#F59E0B`
- Error Red: `#DC2626`
- Background Gray: `#F5F7FA`

### Service Types
Service types are configurable in the `ServiceType` enum:
- Maintenance (Green)
- Repair (Blue)
- Inspection (Yellow)
- Installation (Purple)
- Emergency (Red)

### Working Hours
The calendar displays a 12-hour working day (8 AM - 8 PM). This can be modified in the `CalendarView` widget.

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

1. Follow the existing code structure and naming conventions
2. Add appropriate documentation for new features
3. Ensure all new widgets have proper error handling
4. Test drag-and-drop functionality thoroughly
5. Maintain responsive design principles

## Technical Notes

### Performance Considerations
- Events are filtered efficiently using computed getters
- Large datasets are handled with lazy loading
- Drag operations use proper Flutter drag-and-drop APIs

### Responsive Design
- Sidebar is fixed width (300px) for consistent layout
- Event cards adapt to available space
- Time grid scrolls horizontally for smaller screens

### Error Handling
- All async operations include proper error handling
- User-friendly error messages are displayed via SnackBars
- Failed operations don't crash the application

## Future Enhancements

- [ ] Real-time notifications
- [ ] Calendar synchronization with external systems
- [ ] Mobile-responsive design
- [ ] Multi-language support
- [ ] Advanced reporting features
- [ ] Integration with Perodua's existing systems