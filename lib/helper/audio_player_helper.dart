import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/models/models.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

List<SongModel> mainFinalSongList = [];

class AudioPlayerHelper {
  static AudioPlayer audioPlayer = AudioPlayer();

  static final AudioPlayerHelper _audioPlayerHelper =
      AudioPlayerHelper.internal();

  factory AudioPlayerHelper() {
    return _audioPlayerHelper;
  }

  AudioPlayerHelper.internal();

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}

class PlayerFunctions {
  static final player = AudioPlayer();

  static play(uri, index) async {
    await player.stop();
    await player.setAudioSource(playAll(uri), initialIndex: index);
    await player.play();
  }

  static Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          player.positionStream,
          player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  static ConcatenatingAudioSource playAll(List<SongModel>? data) {
    mainFinalSongList.clear();
    List<AudioSource> sources = [];
    for (var i = 0; i < data!.length; i++) {
      sources.add(AudioSource.uri(
        Uri.parse(data[i].uri!),
        tag: MediaItem(
            id: data[i].id.toString(),
            title: data[i].title,
            artUri: Uri.parse(
                "https://w0.peakpx.com/wallpaper/575/283/HD-wallpaper-music-logo-song.jpg")),
      ));
      mainFinalSongList.add(data[i]);
    }
    return ConcatenatingAudioSource(children: sources);
  }
}

