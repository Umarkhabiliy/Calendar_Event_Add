import 'package:calendar/model/event.dart';
import 'package:calendar/page/eventAddPage.dart';

import 'package:flutter/material.dart';


class EventViewPage extends StatelessWidget {
  final Event event;
  const EventViewPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: makeViewActions(context, event),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          //makeDateTime(event),
          SizedBox(height: 32),
          Text(
            event.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            event.description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
         
        ],
      ),
    );
  }

  // Widget makeDateTime(Event event) {
  //   return Column(
  //     children: [
  //       makeDate(event.isallDay ? "All day" : 'From', event.from),
  //       if (!event.isallDay) makeDate('To', event.to)
  //     ],
  //   );
  // }

  List<Widget> makeViewActions(BuildContext context, Event event) {
    return [
      IconButton(
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EventAddPage(
                        evnt: event,
                      ))),
          icon: Icon(
            Icons.edit,
          )),
      // IconButton(
      //     onPressed: () {
      //       final provider = Provider.of<EventProvider>(context, listen: false);
      //       provider.deleteEvent(evnt);
      //     },
      //     icon: Icon(Icons.delete))
    ];
  }
}
