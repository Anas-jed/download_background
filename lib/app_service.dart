import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:download_background/event_bus.dart';
import 'package:download_background/file_model.dart';
import 'package:download_background/main.dart';

class AppService {
  static AppService? _instance;

  static AppService get getInstance => _instance ?? AppService();
  late Dio _dio;

  final Queue<FileModel> downloadQueue = Queue<FileModel>();
  // static bool isDownloading = false;
  static FileModel? currentFileDownload;
  // StreamController? streamController = StreamController();

  AppService() {
    _dio = Dio();

    // eventBus.on<AddedToQueue>().listen((event) {
    //   log('DownloadEvent Listen : ${event.fileModel.name}');

    // });

    eventBus.on<Download>().listen((event) {
      log('DownloadEvent Listen : ${event.fileModel.name} $currentFileDownload');
      if (downloadQueue.isNotEmpty && currentFileDownload == null) {
        currentFileDownload = downloadQueue.removeFirst();
        startDownloading(currentFileDownload!);
      }
    });

    eventBus.on<DownloadComplete>().listen((event) {
      log('DownloadCompleteEvent Listen : ${event.fileModel.name}');
      currentFileDownload = null;
      eventBus.fire(Download);
    });
  }

  addToQueue(FileModel fileModel) {
    log('addToQueue : ${fileModel.name}');
    downloadQueue.add(fileModel);
    eventBus.fire(Download(fileModel));
  }

  startDownloading(FileModel fileModel) async {
    // stream = _dio.get<ResponseBody>(fileModel.url,
    //         options: Options(responseType: ResponseType.stream));
    log('start Downloading: ${fileModel.name} ${fileModel.url}');
    // var value;
    // final response = _dio.download(fileModel.url,
    //     '/data/user/0/com.example.download_background/cache/${fileModel.name}.pdf',
    //     options: Options(responseType: ResponseType.stream));

    var value;
    _dio.download(
      fileModel.url,
      '/data/user/0/com.example.download_background/cache/${fileModel.name}${fileModel.ext}',
      onReceiveProgress: (received, total) {
        if (total != -1) {
          value = (received / total * 100).toStringAsFixed(0);
          // log("$value% ");
          eventBus.fire(Downloading(fileModel, value));
        }
      },
    ).then((value) {
      log('then : $value ${value.statusCode} ${value.data}');
      eventBus.fire(DownloadComplete(fileModel));
    }).catchError((err) {
      log('here is error $err');
    });
  }

  // void addDownload(int id, String url, String pathToSave) {
  //   log('addDownload called $getDownloadQueueMap $id $url $pathToSave');

  //   if (getDownloadQueueMap.isEmpty) {
  //     log('it is empty');

  //     getDownloadQueueMap.add({'url': url, 'id': id});
  //     Fluttertoast.showToast(
  //       msg: "Your task is added into the queue",
  //     );
  //     startDownloadFile(pathToSave);
  //     // if (getDownloadQueueMap.isNotEmpty) {
  //     //   log('removing');
  //     //   getDownloadQueueMap.removeFirst();
  //     // }
  //     log('addDownload called34 $getDownloadQueueMap');
  //   } else {
  //     log('it is not empty');
  //     getDownloadQueueMap.add({'url': url, 'id': id});
  //     Fluttertoast.showToast(
  //       msg: "Your task is added into the queue",
  //     );
  //   }

  //   eventBus.on<DownloadEvent>().listen((event) {
  //     try {
  //       if (event.progress == 100) {
  //         log('eventProgress comes to : ${event.progress}');
  //         if (getDownloadQueueMap.isNotEmpty) {
  //           log('removing11');
  //           getDownloadQueueMap.removeFirst();
  //         }
  //         startDownloadFile(pathToSave);
  //       }
  //     } catch (e) {
  //       log('exceptions::$e');
  //     }
  //   });
  // }

  // startDownloadFile(String pathToSave) {
  //   try {
  //     log('startDownloadFile called $getDownloadQueueMap');
  //     if (getDownloadQueueMap.isNotEmpty) {
  //       String url = getDownloadQueueMap.first['url'];
  //       int id = getDownloadQueueMap.first['id'];
  //       var value;
  //       _dio.download(
  //         url,
  //         pathToSave,
  //         onReceiveProgress: (received, total) {
  //           if (total != -1) {
  //             value = (received / total * 100).toStringAsFixed(0);
  //             log("$value% of $id");

  //             // if (value != 100) {
  //             eventBus.fire(DownloadEvent(int.parse(value), id));
  //             // }
  //           }
  //         },
  //       ).then((value) {
  //         log('then : $value ${value.statusCode} ${value.data}');
  //         log('then11 : $value ${value.statusCode} ${value.data} ${jsonDecode(value.data)}');
  //       }).catchError((err) {
  //         log('here is error $err');
  //       });
  //     }
  //   } catch (e) {
  //     log('exec: $e');
  //   }
  // }
}
