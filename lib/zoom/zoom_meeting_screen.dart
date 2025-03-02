import 'dart:async';
import 'package:flutter/material.dart';

class ZoomMeetingScreen extends StatefulWidget {
  final userName;
  final meetingId;
  final meetingPassword;

  ZoomMeetingScreen({this.userName, this.meetingId, this.meetingPassword});

  @override
  _MeetingWidgetState createState() => _MeetingWidgetState();
}

class _MeetingWidgetState extends State<ZoomMeetingScreen> {
  Timer? timer;

  @override
  void initState() {
    
    super.initState();
    joinMeeting(context);
  }

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initializing meeting'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue, // foreground
          ),
          onPressed: () async {
            joinMeeting(context);
          },
          child: const Text('Join'),
        ),
      ),
    );
  }

  //API KEY & SECRET is required for below methods to work
  //Join Meeting With Meeting ID & Password
  joinMeeting(BuildContext context) {}
}
