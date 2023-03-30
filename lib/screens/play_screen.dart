import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/helper/audio_player_helper.dart';
import 'package:music_app/models/models.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:music_app/ui_utils/ui_utils.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';

class PlayScreen extends StatefulWidget {
  final List<SongModel> songs;
  final int index;

  const PlayScreen({
    super.key,
    required this.songs,
    required this.index,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with WidgetsBindingObserver {
  int? index;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    // Set index to latest index which is received from previous screen
    index = widget.index;
    // Listen current song's index and update it for home screen and latest index
    PlayerFunctions.player.currentIndexStream.listen((index) {
      if (index != null) {
        // Update latest index to this screen's index.
        this.index = index;
        // Update selected song id to Home screen because when user taps from another song so we can identify
        // whether user tapped same song or another so we can play accordingly
        _updateHomeScreenSelectedId(index: index);
      }
    });
    // Check whether user tapped for different song if yes then play newly tapped song
    if (widget.songs[widget.index].id != HomeScreen.selectedId) {
      // Update on home screen that user has played new song
      HomeScreen.selectedId == widget.songs[widget.index].id;
      // Play newly tapped song
      PlayerFunctions.play(widget.songs, index);
    }
    // Check whether is song playing or not
    PlayerFunctions.player.playingStream.listen((playing) {
      setState(() {
        isPlaying = playing;
      });
    });
  }

  _updateHomeScreenSelectedId({required int index}) {
    setState(() {
      HomeScreen.selectedId = HomeScreen.songsList[index].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show song's name that this song is playing
        title: Text(
            "${widget.songs[index ?? widget.index].displayNameWOExt} Playing"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            const Spacer(),
            // Show song's image
            BuildImage(songId: widget.songs[index ?? widget.index].id),
            const Spacer(),
            // Show song name and artist name
            BuildSongNameWithArtistName(
                songName: widget.songs[index ?? widget.index].displayNameWOExt,
                artistName:
                    widget.songs[index ?? widget.index].artist ?? "Unknown"),
            const Spacer(),
            // Show Progress bar for song
            StreamBuilder<DurationState>(
              stream: PlayerFunctions.durationStateStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final durationState = snapshot.data;
                final progress = durationState?.position ?? Duration.zero;
                final total = durationState?.total ?? Duration.zero;
                return ProgressBar(
                    timeLabelType: TimeLabelType.totalTime,
                    progress: progress,
                    total: total,
                    barHeight: 4,
                    barCapShape: BarCapShape.round,
                    onSeek: (duration) {
                      PlayerFunctions.player.seek(duration);
                    });
              },
            ),
            const Spacer(),
            // Show player buttons which controls the song
            PlayerButtons(
              buttonColor: Colors.blueGrey,
              buttonSize: 30.sp,
              isPlaying: isPlaying,
              nextButtonOnPress: () {
                // Check whether song is last in the list if yes then play first song else next
                if (index == HomeScreen.songsList.length - 1) {
                  PlayerFunctions.play(widget.songs, 0);
                } else {
                  PlayerFunctions.player.seekToNext();
                }
              },
              previousButtonOnPress: () {
                // Check whether song is first if yes then play last of the list else play previous song
                if (index == 0) {
                  PlayerFunctions.play(widget.songs, widget.songs.length - 1);
                } else {
                  PlayerFunctions.player.seekToPrevious();
                }
              },
              playPauseButtonOnPress: () {
                // Check whether song is playing if yes then pause the song else play
                isPlaying
                    ? PlayerFunctions.player.pause()
                    : PlayerFunctions.player.play();
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
