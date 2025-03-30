import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'my_network.dart';
import 'notifications.dart';
import 'guild.dart';
import 'my_home_page.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  File? _videoFile;
  VideoPlayerController? _controller;
  final ImagePicker _picker = ImagePicker();

  // Pick a video from the gallery
  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
        _controller = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
            _controller!.play();
          });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: _pickVideo,
          ),
        ],
      ),
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  VideoProgressIndicator(_controller!, allowScrubbing: true),
                ],
              )
            : const Text("Pick a video to play"),
      ),
      floatingActionButton: _controller != null &&
              _controller!.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller != null && _controller!.value.isInitialized) {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  }
                });
              },
              child: Icon(
                _controller != null && _controller!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 6, 18),
          border: Border.all(
            color: const Color.fromARGB(255, 230, 45, 45),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 234, 7, 7).withOpacity(0.8),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color.fromARGB(255, 241, 238, 241),
          unselectedItemColor: const Color.fromARGB(255, 245, 8, 8),
          currentIndex: 2, // Correct index for Video Page
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: 'My Network'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_call), label: 'Video'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Guild'),
          ],
          onTap: (index) {
            if (index == 0) {
              Get.offAll(() => const MyHomePage());
            } else if (index == 1) {
              Get.offAll(() => const MyNetwork());
            } else if (index == 2) {
              Get.offAll(() => const Video());
            } else if (index == 3) {
              Get.offAll(() => const Notifications());
            } else if (index == 4) {
              Get.offAll(() => const Guild());
            }
          },
        ),
      ),
    );
  }
}
