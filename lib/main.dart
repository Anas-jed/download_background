import 'dart:developer';
import 'dart:io';

import 'package:download_background/file_model.dart';
import 'package:download_background/spring_widget.dart';
import 'package:flutter_svg/svg.dart';

import 'app_service.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'event_bus.dart';

// QueueDownload globalQueueDownload = QueueDownload.getInstance;
EventBus eventBus = EventBus();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Queue Download'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _counter1 = 0;
  String filesDir = '';

  startDownloading(int id, String name) async {
    String pathToSave = await getFileDirectory();

    // if (id == 12) {
    //   var file = File('$pathToSave/$name.pdf');
    //   log('pathToSave: ${file.path}');
    //   AppService.getInstance.addDownload(
    //       id, 'https://research.nhm.org/pdfs/10840/10840-002.pdf', file.path);
    // } else if (id == 54) {
    //   var file1 = File('$pathToSave/$name.pdf');
    //   log('pathToSave: ${file1.path}');
    //   AppService.getInstance.addDownload(
    //       id,
    //       'https://freetestdata.com/wp-content/uploads/2022/11/Free_Test_Data_10.5MB_PDF.pdf',
    //       file1.path);
    // }
  }

  showFiles() async {
    Directory? appDocDir = await getTemporaryDirectory();
    // String appDocPath = appDocDir!.path;
    log('AppDirectory: ${appDocDir.path}');
    var values = await appDocDir.list().toList();
    setState(() {
      filesDir = values.toString();
    });
    log('values: $values');
  }

  Future<String> getFileDirectory() async {
    Directory? appDocDir = await getTemporaryDirectory();
    String appDocPath = appDocDir.path;

    log('appDocPath: $appDocPath');
    return appDocPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Downloading Files',
            // ),
            // const SizedBox(
            //   height: 10,
            // ),

            // SizedBox(
            //   height: 30,
            //   child: StreamBuilder(
            //     // initialData: -1,
            //     stream: AppService.getInstance.streamController!.stream,

            //     builder: (context, snapshot) {
            //       log('ddddd; ${snapshot.data}');
            //       if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //       }
            //       if (!snapshot.hasData) {
            //         return const CircularProgressIndicator();
            //       }
            //       // Use the data from the stream
            //       final data = snapshot.data;

            //       final downloaded = data.downloaded;
            //       final total = data.total;
            //       final progress = downloaded / total;
            //       // Use the progress to show download progress
            //       return Text('progress: $progress');
            //     },
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (context, index) {
                  return FileItemWidget(
                    fileModel: dummyFileModel[index],
                    index: index,
                    onTap: () {
                      log('tapped $index');
                      AppService.getInstance.addToQueue(dummyFileModel[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: dummyFileModel.length),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       '$_counter',
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Text(
            //       '$_counter1',
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Downloaded Files: $filesDir',
                      maxLines: 10,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showFiles();
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const NewScreen()));
            },
            child: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class FileItemWidget extends StatefulWidget {
  final FileModel fileModel;
  final VoidCallback onTap;
  final int index;
  const FileItemWidget(
      {Key? key,
      required this.fileModel,
      required this.onTap,
      required this.index})
      : super(key: key);

  @override
  State<FileItemWidget> createState() => _FileItemWidgetState();
}

class _FileItemWidgetState extends State<FileItemWidget> {
  String progress = '0%';
  bool isDownloading = false;
  @override
  void initState() {
    super.initState();
    eventBus.on<Downloading>().listen((event) {
      if (int.parse(event.progress) > 80) {
        log('DownloadingEvent Listen : ${event.fileModel.name}');
      }

      if (widget.fileModel.name == event.fileModel.name) {
        setState(() {
          progress = event.progress;
          isDownloading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.3)),
      child: Row(
        children: [
          SpringWidget(
            onTap: widget.onTap,
            child: Container(
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: isDownloading
                    ? Text('$progress%')
                    : SvgPicture.asset(
                        'assets/download.svg',
                        color: Colors.green,
                      ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.fileModel.name,
            style: Theme.of(context).textTheme.headline6,
          )
        ],
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('This is new screen')));
  }
}
