/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:chewie/chewie.dart';
import 'package:energielabel_app/ui/know_how/components/media_error_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:video_player/video_player.dart';

class CategoryTipVideoSection extends StatefulWidget {
  const CategoryTipVideoSection({required this.videoUrl});
  final String videoUrl;

  @override
  State<CategoryTipVideoSection> createState() => _CategoryTipContentVideoSection();
}

class _CategoryTipContentVideoSection extends State<CategoryTipVideoSection> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _playerInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_playerInitialized) {
      return Chewie(controller: _chewieController);
    } else if (_hasError) {
      return MediaErrorWidget.video();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void _initVideoPlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, message) {
          Fimber.e('Video playback failure. Message: $message.');
          return MediaErrorWidget.video();
        },
      );

      setState(() {
        _playerInitialized = true;
        _hasError = false;
      });
    }).catchError((error) {
      Fimber.w('Failed to initialize video player.', ex: error);

      setState(() {
        _playerInitialized = false;
        _hasError = true;
      });
    });
  }
}
