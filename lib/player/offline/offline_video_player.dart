// //import 'package:better_player/better_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import '../custom_player.dart';

// class OfflineVideoPlayer extends StatefulWidget {
//   OfflineVideoPlayer({this.file});

//   final String? file;

//   @override
//   _OfflineVideoPlayerState createState() => _OfflineVideoPlayerState();
// }

// class _OfflineVideoPlayerState extends State<OfflineVideoPlayer> {
//  // BetterPlayerController? _betterPlayerController;
//   var betterPlayerConfiguration;

//   @override
//   void initState() {
//     super.initState();
//     offlineVideoPlayer(videoFile: widget.file);
//   }

//   offlineVideoPlayer({String? videoFile}) {
//     if (_betterPlayerController != null) {
//       if (_betterPlayerController!.isPlaying() as bool) {
//         _betterPlayerController!.pause();
//       }
//       _betterPlayerController!.clearCache();
//     }

//     if (_betterPlayerController == null) {
//       // This player supports all format mentioned in following URL
//       // https://exoplayer.dev/supported-formats.html
//       var dataSource = BetterPlayerDataSource(
//         BetterPlayerDataSourceType.file,
//         "$videoFile",
//       );
//       betterPlayerConfiguration = BetterPlayerConfiguration(
//         autoPlay: true,
//         looping: false,
//         fullScreenByDefault: false,
//         aspectRatio: 16 / 9,
//         subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
//             fontSize: 20,
//             fontColor: Colors.white,
//             backgroundColor: Colors.black),
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//           textColor: Colors.white,
//           iconsColor: Colors.white,
//         ),
//       );
//       _betterPlayerController = BetterPlayerController(
//         betterPlayerConfiguration,
//         betterPlayerDataSource: dataSource,
//       );
//       _betterPlayerController!.play();
//     } else {
//       // This player supports all format mentioned in following URL
//       // https://exoplayer.dev/supported-formats.html
//       _betterPlayerController!.pause();
//       _betterPlayerController = null;
//       var dataSource = BetterPlayerDataSource(
//         BetterPlayerDataSourceType.file,
//         "$videoFile",
//       );
//       betterPlayerConfiguration = BetterPlayerConfiguration(
//         autoPlay: true,
//         looping: false,
//         fullScreenByDefault: false,
//         aspectRatio: 16 / 9,
//         subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
//             fontSize: 20,
//             fontColor: Colors.white,
//             backgroundColor: Colors.black),
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//           textColor: Colors.white,
//           iconsColor: Colors.white,
//         ),
//       );
//       _betterPlayerController = BetterPlayerController(
//         betterPlayerConfiguration,
//         betterPlayerDataSource: dataSource,
//       );
//       _betterPlayerController!.play();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(translate("Video_Player")),
//       ),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Container(
//           height: 220.0,
//           // child: CustomPlayer(_betterPlayerController!),
//         ),
//       ),
//     );
//   }
// }
