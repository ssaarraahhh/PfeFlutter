import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';





class VideoPlayerScreen2 extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen2({this.videoUrl});

  @override
  _VideoPlayerScreen2State createState() => _VideoPlayerScreen2State();
}

class _VideoPlayerScreen2State extends State<VideoPlayerScreen2> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _chewieController != null
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Chewie(
                controller: _chewieController,
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
