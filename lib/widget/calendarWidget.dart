import 'package:calendar/model/eventDataSource.dart';
import 'package:calendar/provider/evntProvider.dart';
import 'package:calendar/widget/taskWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final evnts = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      //we can choose other views(day,schedule..etc)
      view: CalendarView.month,
      initialDisplayDate: DateTime.now(),
      dataSource: EventDataSource(evnts),
      
      cellBorderColor: Colors.white,
      onLongPress: (detail) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(detail.date!);
        showModalBottomSheet(
            context: context, builder: (context) => TaskWidget());
      },
    );
  }
}
