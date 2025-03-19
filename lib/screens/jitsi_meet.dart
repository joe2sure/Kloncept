import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/model/content_model.dart';
import 'package:kloncept/model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:provider/provider.dart';
import '../provider/user_profile.dart';

class JitsiMeetingJoin extends StatefulWidget {
  final JitsiMeeting? jitsiMeeting;

  JitsiMeetingJoin({this.jitsiMeeting});

  @override
  _JitsiMeetingJoinState createState() => _JitsiMeetingJoinState();
}

class _JitsiMeetingJoinState extends State<JitsiMeetingJoin> {
  JitsiMeeting? _jitsiMeeting;

  UserProfileModel? _userProfileModel;

  @override
  void initState() {
    super.initState();

    _jitsiMeeting = widget.jitsiMeeting;

    // _userProfileModel =
    //     Provider.of<UserProfile>(context, listen: false).profileInstance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("Jitsi_Meet")),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: meetConfig(),
      ),
    );
  }

  Widget meetConfig() {
    return Center(
      child: SizedBox(
        height: 60.0,
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            _joinMeeting();
            Fluttertoast.showToast(msg: "N/A", backgroundColor: Colors.red);
          },
          child: Text(
            "Join Meeting Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  _joinMeeting() async {
    String? serverUrl;

    Map<String, Object> featureFlags = {};

    // Define meetings options here
    var options = JitsiMeetingOptions(
      roomNameOrUrl: _jitsiMeeting!.meetingId.toString(),
      serverUrl: serverUrl,
      subject: _jitsiMeeting!.meetingTitle,
      isAudioMuted: true,
      isAudioOnly: false,
      isVideoMuted: true,
      userDisplayName:
          "${_userProfileModel!.fname} ${_userProfileModel!.lname}",
      userEmail: _userProfileModel!.email,
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
            "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
            "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
            "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
            "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
  }
}
