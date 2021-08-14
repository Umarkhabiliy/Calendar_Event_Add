import 'package:calendar/model/eventDataSource.dart';
import 'package:calendar/page/eventView.dart';
import 'package:calendar/provider/evntProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventofSelectedDate;
    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          "No Events found!",
          style: TextStyle(color: Colors.black87, fontSize: 24),
        ),
      );
    }
    return SfCalendar(
       view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appoitmentBuilder,
      headerHeight: 0,
      todayHighlightColor: Colors.black,
      selectionDecoration: BoxDecoration(color: Colors.red.withOpacity(0.3)),
      onTap: (details) {
        if (details.appointments == null) return;
        final event = details.appointments!.first;
       Navigator.of(context).push(MaterialPageRoute(
           builder: (context) => EventViewPage(event: event)));
      },
    );
  }

  Widget appoitmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;
    return Container(
      decoration: BoxDecoration(
          color: event.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      width: details.bounds.width,
      height: details.bounds.height,
      child: Center(
          child: Text(
        event.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      )),
    );
  }
}
