import 'package:flutter/material.dart';
import 'package:music_app/helper/audio_player_helper.dart';
import 'package:music_app/helper/offline_audio_query.dart';
import 'package:music_app/ui_utils/ui_utils.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  // static song list
  static List<SongModel> songsList = [];
  // static home screen selected ID
  static dynamic selectedId;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
  bool loading = true;
  bool permissionStatus = false;

  @override
  void initState() {
    super.initState();
    initialTasks().then((value) {
      PlayerFunctions.player.currentIndexStream.listen((index) {
        if (index != null) {
          setState(() {
            HomeScreen.selectedId =
                HomeScreen.songsList[PlayerFunctions.player.currentIndex!].id;
          });
        }
      });
    });
  }

  Future<void> initialTasks() async {
    // ask for internal storage permission
    permissionStatus = await offlineAudioQuery.requestPermission();
    if (permissionStatus) {
      // Get songs from the internal storage
      HomeScreen.songsList = await offlineAudioQuery.getSongs(
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: SongSortType.TITLE,
      );
      debugPrint(
          "KevalDebug - Home screen song List Length = ${HomeScreen.songsList.length}");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : permissionStatus
              ? HomeScreen.songsList.isEmpty
                  ? const Center(
                      child: Text("No songs found"),
                    )
                  : ListView.builder(
                      itemCount: HomeScreen.songsList.length,
                      itemBuilder: (context, index) {
                        return ListItem(
                            songs: HomeScreen.songsList, index: index);
                      },
                    )
              : const Center(
                  child: Text(
                      "No Permission found.\nYou need to give permission from settings now"),
                ),
    );
  }
}
