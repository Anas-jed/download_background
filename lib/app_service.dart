import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:download_background/event_bus.dart';
import 'package:download_background/file_model.dart';
import 'package:download_background/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppService {
  static AppService? _instance;

  static AppService get getInstance => _instance ?? AppService();
  late Dio _dio;
  static Queue<Map>? _downloadQueueMap;

  static Queue<Map> get getDownloadQueueMap => _downloadQueueMap ??= Queue();

  

  AppService() {
    _dio = Dio();
  }

  addToQueue(FileModel fileModel){

  }

  void addDownload(int id, String url, String pathToSave) {
    log('addDownload called $getDownloadQueueMap $id $url $pathToSave');

    if (getDownloadQueueMap.isEmpty) {
      log('it is empty');

      getDownloadQueueMap.add({'url': url, 'id': id});
      Fluttertoast.showToast(
          msg: "Your task is added into the queue",
      );
      startDownloadFile(pathToSave);
      // if (getDownloadQueueMap.isNotEmpty) {
      //   log('removing');
      //   getDownloadQueueMap.removeFirst();
      // }
      log('addDownload called34 $getDownloadQueueMap');
    } else {
      log('it is not empty');
      getDownloadQueueMap.add({'url': url, 'id': id});
      Fluttertoast.showToast(
        msg: "Your task is added into the queue",
      );
    }

    eventBus.on<DownloadEvent>().listen((event) {
      try{
        if (event.progress == 100) {
          log('eventProgress comes to : ${event.progress}');
          if (getDownloadQueueMap.isNotEmpty) {
            log('removing11');
            getDownloadQueueMap.removeFirst();
          }
          startDownloadFile(pathToSave);
        }
      }catch(e){
        log('exceptions::$e');
      }
    });
  }

  startDownloadFile(String pathToSave) {
    try{
      log('startDownloadFile called $getDownloadQueueMap');
      if (getDownloadQueueMap.isNotEmpty) {
        String url = getDownloadQueueMap.first['url'];
        int id = getDownloadQueueMap.first['id'];
        var value;
        _dio.download(url, pathToSave, onReceiveProgress: (received, total) {
          if (total != -1) {
            value = (received / total * 100).toStringAsFixed(0);
            log("$value% of $id");

            // if (value != 100) {
            eventBus.fire(DownloadEvent(int.parse(value), id));
            // }
          }
        },).then((value) {
          log('then : $value ${value.statusCode} ${value.data}');
          log('then11 : $value ${value.statusCode} ${value.data} ${jsonDecode(value.data)}');
        }).catchError((err){
          log('here is error $err');
        });
      }
    }catch(e){
      log('exec: $e');
    }
  }
}
