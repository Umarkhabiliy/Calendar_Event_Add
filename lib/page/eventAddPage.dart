import 'package:calendar/model/event.dart';
import 'package:calendar/provider/evntProvider.dart';
import 'package:calendar/utilis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventAddPage extends StatefulWidget {
  final Event? evnt;
  const EventAddPage({Key? key, this.evnt}) : super(key: key);

  @override
  _EventAddPageState createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  late DateTime fromDate;
  late DateTime toDate;
  var _formKey = GlobalKey<FormState>();
  TextEditingController textTitleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.evnt == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.evnt!;
      textTitleEditingController.text = event.title;
      descriptionEditingController.text = event.description;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    textTitleEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, elevation: 0.0),
              onPressed: saveForm,
              icon: Icon(Icons.done),
              label: Text("Done"))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              makeTitle(),
              SizedBox(height: 12),
              makeFrom(),
              makeTo(),
              Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              makeDescirption()
            ],
          ),
        ),
      ),
    );
  }

  Widget makeTitle() {
    return TextFormField(
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: "Sarlavha kiriting"),
        controller: textTitleEditingController,
        validator: (text) {
          if (text!.isEmpty) {
            return "Sarlavaha bo'sh bo'lishi mumkin emas";
          }
        },
        onFieldSubmitted: (evnt) => saveForm());
  }

  Widget makeDescirption() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          maxLines: 8,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Malumot kiriting"),
          controller: descriptionEditingController,
          validator: (text) {
            if (text!.isEmpty) {
              return "Malumot bo'sh bo'lishi mumkin emas";
            }
          },
          onFieldSubmitted: (evnt) => saveForm()),
    );
  }

  Widget makeDatePicker() {
    return Column(
      children: [makeFrom(), makeTo()],
    );
  }

  Widget makeFrom() {
    return makeHeader(
        header: "From",
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: makeDropdownField(
                    text: Utils.toDate(fromDate),
                    onClicked: () => pickFromDateTime(pickDate: true))),
            Expanded(
                child: makeDropdownField(
                    text: Utils.toTime(fromDate),
                    onClicked: () => pickFromDateTime(pickDate: false))),
          ],
        ));
  }

  Widget makeTo() {
    return makeHeader(
        header: "TO",
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: makeDropdownField(
                    text: Utils.toDate(toDate),
                    onClicked: () => pickToDateTime(pickDate: true))),
            Expanded(
                child: makeDropdownField(
                    text: Utils.toTime(toDate),
                    onClicked: () => pickToDateTime(pickDate: false))),
          ],
        ));
  }

  Widget makeDropdownField(
      {required String text, required VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  Widget makeHeader({required String header, required Widget child}) {
    return Column(
      children: [
        Text(
          header,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        child
      ],
    );
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final evnt = Event(
          title: textTitleEditingController.text,
          description: descriptionEditingController.text,
          from: fromDate,
          to: toDate,
          isallDay: false);
      final isEditing = widget.evnt != null;
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(evnt);

      if (isEditing) {
        provider.editEvent(evnt, widget.evnt!);
        Navigator.of(context).pop();
      } else {
        provider.addEvent(evnt);
        Navigator.of(context).pop();
      }
    }
  }

//From DATE
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      fromDate,
      pickDate: pickDate,
    );
    if (date == null) return null;

    //inital qismidagi vaqt pastdagi vaqtdan  o'tib ketsa
    //initial bilan bir hil qilib olish uchun
    if (date.isAfter(toDate)) {
      toDate = DateTime(date.year, date.month, toDate.hour, toDate.minute);
    }
    setState(() {
      fromDate = date;
    });
  }

  //TODATE
  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);

    if (date == null) return null;

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(1996, 10),
          lastDate: DateTime(2100));
      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
}
