import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayAudio extends StatefulWidget {
  PlayAudio({this.url});
  final dynamic url;
  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio>
    with SingleTickerProviderStateMixin {
  //we will need some variables
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon
  late AnimationController _controller;

  late AudioPlayer _player;

  AudioCache? cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider() {
    return Slider(
      onChanged: (v) {
        setState(() {
          _player.seek(Duration(seconds: v.round()));
        });
      },
      value: position.inSeconds.toDouble(),
      max: musicLength.inSeconds.toDouble(),
      min: 0.0,
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    print("sec: $sec");
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration:
          Duration(seconds: 1), // how long should the animation take to finish
    );
    _player = AudioPlayer();

    doGetDurationStuff();
    doGetPositionHandlerStuff();

    //this function will allow you to get the music duration
    _player.onDurationChanged.listen((d) {
      setState(() {
        musicLength = d;
      });
    });

    _player.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  Future<void> doGetDurationStuff() async {
    //this function will allow you to get the music duration
    int d = int.parse(_player.getDuration().toString());
    setState(() {
      musicLength = Duration(milliseconds: d);
    });
  }

  Future<void> doGetPositionHandlerStuff() async {
    //this function will allow you to get the music duration
    int d = int.parse(_player.getDuration().toString());
    setState(() {
      musicLength = Duration(milliseconds: d);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _player.dispose();
  }

  Future<void> _play() async {
    String url = '${widget.url}';
    final playPosition = (position.inMilliseconds > 0 &&
            position.inMilliseconds < musicLength.inMilliseconds)
        ? position
        : null;
    if (url.contains('http'))
      await _player.play(UrlSource(url), position: playPosition);
    else
      await _player.play(DeviceFileSource(url), position: playPosition);
  }

  @override
  Widget build(BuildContext context) {
    if (position.inSeconds > 0 && position.inSeconds == musicLength.inSeconds) {
      _controller.reverse();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 35.0,
              color: Colors.blue[800],
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _controller,
              ),
              onPressed: () {
                //here we will add the functionality of the play button
                try {
                  if (!playing) {
                    _play();
                    _controller.forward();
                    setState(() {
                      playBtn = Icons.pause;
                      playing = true;
                    });
                  } else {
                    _player.pause();
                    _controller.reverse();
                    setState(() {
                      playBtn = Icons.play_arrow;
                      playing = false;
                    });
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 1, child: slider()),
            Text(
              " ${position.inHours} : ${position.inMinutes.remainder(60)} : ${position.inSeconds.remainder(60)}",
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
