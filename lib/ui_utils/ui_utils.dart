import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:music_app/screens/play_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';

// Build list item for song for example home screen song item
class ListItem extends StatelessWidget {
  final List<SongModel> songs;
  final dynamic index;

  const ListItem({
    Key? key,
    required this.songs,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        debugPrint(
            "KevalDebug - song id - ${songs[index].id}, Home screen selected id - ${HomeScreen.selectedId}");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PlayScreen(songs: songs, index: index)));
      },
      leading: QueryArtworkWidget(
        id: songs[index].id,
        type: ArtworkType.AUDIO,
        artworkFit: BoxFit.cover,
        artworkBorder: BorderRadius.circular(100),
      ),
      title: Container(
        padding: EdgeInsets.only(right: 10.sp),
        child: Text(
          songs[index].title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(songs[index].artist ?? "Unknown"),
      trailing: Icon(
        Icons.more_vert,
        color: Colors.black,
        size: 30.sp,
      ),
    );
  }
}


// Build image for song image for example player screen shows image
class BuildImage extends StatelessWidget {
  final int songId;
  final int? height;
  final int? width;

  const BuildImage({
    Key? key,
    required this.songId,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: songId,
      type: ArtworkType.AUDIO,
      artworkQuality: FilterQuality.high,
      quality: 100,
      artworkBorder: BorderRadius.circular(25),
      artworkHeight: height?.h ?? 50.h,
      artworkWidth: width?.h ?? 100.h,
    );
  }
}


// Build song's name and artist name
class BuildSongNameWithArtistName extends StatelessWidget {
  final String songName;
  final String artistName;
  final bool showLikeButton;

  const BuildSongNameWithArtistName({
    Key? key,
    required this.songName,
    required this.artistName,
    this.showLikeButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        songName,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        artistName,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}


// Build player buttons like play, pause, next, previous
class PlayerButtons extends StatefulWidget {
  final Color buttonColor;
  final dynamic buttonSize;
  final bool isPlaying;

  final VoidCallback nextButtonOnPress;
  final VoidCallback previousButtonOnPress;
  final VoidCallback playPauseButtonOnPress;

  const PlayerButtons({
    Key? key,
    required this.buttonColor,
    required this.buttonSize,
    required this.isPlaying,
    required this.nextButtonOnPress,
    required this.previousButtonOnPress,
    required this.playPauseButtonOnPress,
  }) : super(key: key);

  @override
  State<PlayerButtons> createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Spacer(),
        IconButton(
          onPressed: widget.previousButtonOnPress,
          icon: Icon(
            Icons.skip_previous,
            size: widget.buttonSize,
            color: widget.buttonColor,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: widget.playPauseButtonOnPress,
          icon: widget.isPlaying
              ? Icon(
                  Icons.pause_circle,
                  size: widget.buttonSize,
                  color: widget.buttonColor,
                )
              : Icon(
                  Icons.play_circle,
                  size: widget.buttonSize,
                  color: widget.buttonColor,
                ),
        ),
        const Spacer(),
        IconButton(
          onPressed: widget.nextButtonOnPress,
          icon: Icon(
            Icons.skip_next,
            size: widget.buttonSize,
            color: widget.buttonColor,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
