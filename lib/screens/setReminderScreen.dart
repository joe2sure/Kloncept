import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../Widgets/appbar.dart';
import 'package:intl/intl.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({this.title, this.description});

  final String? title;
  final String? description;

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

bool isSaving = false;

class _SetReminderScreenState extends State<SetReminderScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController eventTitle = TextEditingController();
  TextEditingController eventDescription = TextEditingController();
  TextEditingController eventStartDate = TextEditingController();
  TextEditingController eventStartTime = TextEditingController();
  TextEditingController eventEndDate = TextEditingController();
  TextEditingController eventEndTime = TextEditingController();

  @override
  void initState() {
    eventTitle.text = widget.title.toString();
    eventDescription.text = _parseHtmlString(widget.description.toString());
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Set_Reminder"),
      body: LoadingOverlay(
        isLoading: isSaving,
        progressIndicator: CircularProgressIndicator(
          color: Colors.red,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Event Title.';
                      }
                      return null;
                    },
                    autofocus: true,
                    controller: eventTitle,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Enter Event Title',
                      labelText: 'Event Title',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Event Description.';
                      }
                      return null;
                    },
                    controller: eventDescription,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter Event Description',
                      labelText: 'Event Description',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Event Start Date.';
                      }
                      return null;
                    },
                    onTap: () async {
                      await _startDate(context);
                    },
                    controller: eventStartDate,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: 'Enter Event Start Date',
                      labelText: 'Event Start Date',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Event End Date.';
                      }
                      return null;
                    },
                    onTap: () async {
                      await _endDate(context);
                    },
                    controller: eventEndDate,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: 'Enter Event End Date',
                      labelText: 'Event End Date',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xfff44a4a),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            isSaving = true;
                          });
                          await setEvent();
                          setState(() {
                            isSaving = false;
                          });
                        }
                      },
                      child: Text(
                        'Set',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setEvent() async {
    try {
      final Event event = Event(
        title: eventTitle.text,
        description: eventDescription.text,
        location: 'eClass',
        startDate: DateFormat("dd/MM/yyyy hh:mm a").parse(eventStartDate.text),
        endDate: DateFormat("dd/MM/yyyy hh:mm a").parse(eventEndDate.text),
        iosParams: IOSParams(
          reminder: Duration(
              /* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
        ),
        androidParams: AndroidParams(
          emailInvites: [], // on Android, you can add invite emails to your event.
        ),
      );
      await Add2Calendar.addEvent2Cal(event);
    } catch (e) {
      print("setEvent Exception: $e");
    }
  }

  DateTime startDate = DateTime.now();

  Future<void> _startDate(
    BuildContext context,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startDate)
      setState(() {
        startDate = picked;
        String formattedDate = DateFormat('dd/MM/yyyy').format(startDate);
        eventStartDate.text = formattedDate;
        _startTime(context);
      });
  }

  TimeOfDay startTime = TimeOfDay.now();

  Future<Null> _startTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (picked != null && picked != startTime)
      setState(() {
        startTime = picked;
        String formattedTime = formatTimeOfDay(startTime);
        eventStartDate.text += ' ' + formattedTime;
      });
  }

  DateTime endDate = DateTime.now();

  Future<void> _endDate(
    BuildContext context,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != endDate)
      setState(() {
        endDate = picked;
        String formattedDate = DateFormat('dd/MM/yyyy').format(endDate);
        eventEndDate.text = formattedDate;
        _endTime(context);
      });
  }

  TimeOfDay endTime = TimeOfDay.now();

  Future<Null> _endTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (picked != null && picked != endTime)
      setState(() {
        endTime = picked;
        String formattedTime = formatTimeOfDay(endTime);
        eventEndDate.text += ' ' + formattedTime;
      });
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }
}
