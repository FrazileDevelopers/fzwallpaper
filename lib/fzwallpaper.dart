import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Fzwallpaper {
  static const MethodChannel _channel = const MethodChannel('fzwallpaper');

  /// This function is returning the platform version of the device.
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// This function is setting the image to the home screen as a wallpaper.
  static Future<String> homeScreen() async {
    final String resultvar =
        await _channel.invokeMethod('HomeScreen', 'myimage.jpeg');
    return resultvar;
  }

  /// This function is setting the image to the lock screen as a wallpaper.
  static Future<String> lockScreen() async {
    final String resultvar =
        await _channel.invokeMethod('LockScreen', 'myimage.jpeg');
    return resultvar;
  }

  /// This function is setting the image to the home & lock both screen as a wallpaper.
  static Future<String> bothScreen() async {
    final String resultvar =
        await _channel.invokeMethod('Both', 'myimage.jpeg');
    return resultvar;
  }

  /// This function is returning the image downloading progress.
  static Stream<String> imageDownloadProgress(String url) async* {
    StreamController<String> streamController = new StreamController();
    try {
      final dir = await getTemporaryDirectory();
      Dio dio = new Dio();
      dio
          .download(
            url,
            "${dir.path}/myimage.jpeg",
            onReceiveProgress: (int received, int total) {
              streamController
                  .add(((received / total) * 100).toStringAsFixed(0) + "%");
            },
          )
          .then((Response response) {})
          .catchError((ex) {
            streamController.add(ex.toString());
          })
          .whenComplete(() {
            streamController.close();
          });
      yield* streamController.stream;
    } catch (ex) {
      throw ex;
    }
  }
}
