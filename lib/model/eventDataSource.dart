import 'package:calendar/model/event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;
  @override
  DateTime getEndTime(int index) => getEvent(index).to;
  @override
  String  getSubject(int index) => getEvent(index).title;

  String  getSubname(int index) => getEvent(index).description;
  
  @override
   Color getColor(int index) => getEvent(index).backgroundColor;
  
  bool isallDay (int index) => getEvent(index).isallDay;
}
