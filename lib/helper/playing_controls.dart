import 'package:flutter/material.dart';

class PlayingControls extends StatelessWidget {
  final bool isPlaying;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? onStop;
  final Color buttonColor;
  final dynamic buttonSize;

  const PlayingControls({
    Key? key,
    required this.isPlaying,
    required this.onPlay,
    required this.buttonColor,
    required this.buttonSize,
    this.isPlaylist = false,
    this.onPrevious,
    this.onStop,
    this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Spacer(),
        IconButton(
          onPressed: isPlaylist ? onPrevious : null,
          icon: Icon(
            Icons.skip_previous,
            size: buttonSize,
            color: buttonColor,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onPlay,
          icon: isPlaying
              ? Icon(
                  Icons.pause_circle,
                  size: buttonSize,
                  color: buttonColor,
                )
              : Icon(
                  Icons.play_circle,
                  size: buttonSize,
                  color: buttonColor,
                ),
        ),
        const Spacer(),
        IconButton(
          onPressed: isPlaylist ? onNext : null,
          icon: Icon(
            Icons.skip_next,
            size: buttonSize,
            color: buttonColor,
          ),
        ),
        const Spacer(),
        if (onStop != null)
          IconButton(
            onPressed: onStop,
            icon: Icon(
              Icons.stop,
              size: buttonSize,
              color: buttonColor,
            ),
          ),
        const Spacer(),
      ],
    );
  }
}
