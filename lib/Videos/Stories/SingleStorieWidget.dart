import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SingleStorieModel.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/About/Settings/ThemeProvider/model_theme.dart';

class SingleStorieWidget extends StatefulWidget {
  final SingleStorieModel singleStorieModel;
  const SingleStorieWidget({Key? key, required this.singleStorieModel})
      : super(key: key);

  @override
  State<SingleStorieWidget> createState() => _SingleStorieWidgetState();
}

class _SingleStorieWidgetState extends State<SingleStorieWidget>
    with AutomaticKeepAliveClientMixin<SingleStorieWidget> {
  final GlobalKey _betterPlayerKey = GlobalKey();
  late int? _currentPosition;
  var _isVideoStorySaving = true;
  late int _savedPosition = 0;
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    super.initState();
    getData();

    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.singleStorieModel.video_link,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.singleStorieModel.name,
        author: "Открытый университет РГППУ",
        imageUrl: widget.singleStorieModel.img_link,
        activityName: "MainActivity",
      ),
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 50000,
        maxBufferMs: 13107200,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
    );
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSubtitles: false,
          enableAudioTracks: false,
          enableQualities: false,
          enablePlaybackSpeed: false,
          showControlsOnInitialize: false,
          enableOverflowMenu: false),
      autoPlay: true,
      looping: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ],
      allowedScreenSleep: false,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
        betterPlayerDataSource: _betterPlayerDataSource);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType.name == "initialized") {
        _betterPlayerController.seekTo(Duration(seconds: _savedPosition));
      }
      if (event.betterPlayerEventType.name == "openFullscreen") {
        _betterPlayerController.setOverriddenFit(BoxFit.fitHeight);
      }
      if (event.betterPlayerEventType.name == "hideFullscreen") {
        _betterPlayerController.setOverriddenFit(BoxFit.fill);
      }
      if (event.betterPlayerEventType.name == "progress") {
        if (_isVideoStorySaving == true) {
          setState(() {
            _currentPosition = _betterPlayerController
                .videoPlayerController?.value.position.inSeconds;
            saveData(_currentPosition);
          });
        }
      }
    });
    _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
  }

  void saveData(data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        "stories_${widget.singleStorieModel.id.toString()}", data);
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt("stories_${widget.singleStorieModel.id.toString()}") !=
          null) {
        _savedPosition =
            prefs.getInt("stories_${widget.singleStorieModel.id.toString()}")!;
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoStorySaving = prefs.getBool("VideoWatchedSaving")!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
              ? const Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              kIsWeb
                  ? Container(
                      height: 300,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.red,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Тут находится видео",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 16 * 9,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: BetterPlayer(
                          controller: _betterPlayerController,
                          key: _betterPlayerKey,
                        ),
                      )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                child: Text(
                  widget.singleStorieModel.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                  child: Text(
                    widget.singleStorieModel.desc,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
