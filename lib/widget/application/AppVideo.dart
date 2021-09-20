import 'dart:async';
import 'dart:io';

import 'package:exservice/bloc/StatePusher.dart';
import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_font_size.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/widget/buttons/CustomAppButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppVideo extends StatefulWidget {
  final dynamic dataSource;
  final bool fit;
  final bool enablePause;

  const AppVideo.network(String url,
      {Key key, this.enablePause = false, this.fit = true})
      : dataSource = url,
        super(key: key);

  const AppVideo.file(File file,
      {Key key, this.enablePause = false, this.fit = true})
      : dataSource = file,
        super(key: key);

  @override
  _AppVideoState createState() => _AppVideoState();
}

class _AppVideoState extends State<AppVideo>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController _controller;
  final _pusher = StatePusher<bool>.behavior();
  Timer _debounce;
  Duration _debounceDuration = Duration(seconds: 3);
  bool _paused = false;

  @override
  void initState() {
    if (widget.dataSource is String) {
      _controller = VideoPlayerController.network(widget.dataSource);
    } else {
      _controller = VideoPlayerController.file(widget.dataSource);
    }
    _controller.initialize().then((_) {
      setState(() {
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        if (widget.enablePause) {
          _controller.pause();
        }
      });
    }).catchError((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pusher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller.value.hasError) {
      return Center(
        child: Text(
          AppLocalization.of(context).trans('canNotDisplayVideo'),
          style: AppTextStyle.mediumBlue,
          textAlign: TextAlign.center,
        ),
      );
    }
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (VisibilityInfo info) {
        print("${info.visibleFraction}% is visible");
        if (!mounted) return;
        if (info.visibleFraction > 0.6 &&
            _paused == true &&
            widget.enablePause == false) {
          print("video play");
          _paused = false;
          _controller.play();
        } else if (info.visibleFraction < 0.6 && _paused == false) {
          print("video pause");
          _paused = true;
          _controller.pause();
        }
      },
      child: !_controller.value.isInitialized
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Stack(
              children: <Widget>[
                GestureDetector(
                  child: Builder(builder: (context) {
                    if (widget.fit) {
                      return SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size?.width ?? 0,
                            height: _controller.value.size?.height ?? 0,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      );
                    } else {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    }
                  }),
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: () {
                    if (widget.enablePause == true) {
                      if (_paused == true) {
                        print("video play");
                        _paused = false;
                        _controller.play();
                      } else if (_paused == false) {
                        print("video pause");
                        _paused = true;
                        _controller.pause();
                      }
                    }
                  },
                  onTap: () {
                    _pusher.push(false);
                    if (_debounce != null && _debounce.isActive)
                      _debounce.cancel();
                    _debounce = Timer(_debounceDuration, () {
                      if (!mounted) return;
                      _pusher.push(true);
                    });
                  },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: StreamBuilder<bool>(
                    stream: _pusher.stream,
                    initialData: true,
                    builder: (context, snapshot) {
                      return VolumeButton(_controller, snapshot.data);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VolumeButton extends ImplicitlyAnimatedWidget {
  final VideoPlayerController controller;
  final bool hide;

  VolumeButton(this.controller, this.hide, {Key key})
      : super(
          key: key,
          duration: Duration(milliseconds: 200),
          // curve: curve,
        );

  @override
  _VolumeButtonState createState() => _VolumeButtonState();
}

class _VolumeButtonState extends AnimatedWidgetBaseState<VolumeButton> {
  Tween<double> _tween;
  bool _mute = false;

  @override
  void initState() {
    _mute = widget.controller.value.volume == 0.0;
    super.initState();
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween = visitor(
      _tween,
      widget.hide ? 0.0 : 1.0,
      (value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _tween.evaluate(animation),
      child: CustomAppButton(
        key: ValueKey(_mute),
        borderRadius: BorderRadius.circular(50),
        color: AppColors.black.withOpacity(0.8),
        child: Icon(
          _mute ? Icons.volume_off : Icons.volume_up,
          color: AppColors.white,
          size: AppFontSize.LARGE,
        ),
        onTap: _tween.evaluate(animation) != 1.0
            ? null
            : () {
                setState(() {
                  if (_mute) {
                    _mute = false;
                    widget.controller.setVolume(1.0);
                  } else {
                    _mute = true;
                    widget.controller.setVolume(0.0);
                  }
                });
              },
      ),
    );
  }
}
