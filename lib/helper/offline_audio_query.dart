import 'package:on_audio_query/on_audio_query.dart';

class OfflineAudioQuery{
  static OnAudioQuery audioQuery = OnAudioQuery();

  Future<bool> requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if(!permissionStatus){
      permissionStatus =  await audioQuery.permissionsRequest();
    }
    return permissionStatus;
  }

  Future<List<SongModel>> getSongs({
    SongSortType? sortType,
    OrderType? orderType,
    String? path,
  }) async {
    return audioQuery.querySongs(
      sortType: sortType ?? SongSortType.DATE_ADDED,
      orderType: orderType ?? OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      path: path,
    );
  }
}
