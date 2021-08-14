import 'package:calendar/page/eventAddPage.dart';
import 'package:calendar/provider/evntProvider.dart';
import 'package:calendar/widget/calendarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String title = "Calendar";
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => EventProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark().copyWith(
            
            accentColor: Colors.white,
          ),
          home: MainPage(),
        ),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(MyApp.title),actions: [ElevatedButton.icon(icon: Icon(Icons.event),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EventAddPage()));
          },
          label: Text("Add Events"),
          style: ElevatedButton.styleFrom(primary: Colors.transparent,elevation: 0.0)),],),
      body: CalendarWidget(),
     
    );
  }
}
