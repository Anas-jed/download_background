// import 'dart:developer';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   final ReceivePort _port = ReceivePort();
//
//   void _incrementCounter() async {
//     setState(() {
//       _counter++;
//     });
//
//     try {
//       Directory? appDocDir = await getExternalStorageDirectory();
//       String appDocPath = appDocDir!.path;
//       log('appDocPath: $appDocPath');
//       final taskId = await FlutterDownloader.enqueue(
//         url: 'https://research.nhm.org/pdfs/10840/10840.pdf',
//         headers: {},
//         // optional: header send with url (auth token etc)
//         savedDir: appDocPath,
//         saveInPublicStorage: true,
//         showNotification: true,
//         // show download progress in status bar (for Android)
//         openFileFromNotification:
//         false, // click on notification to open downloaded file (for Android)
//       );
//
//       final taskId2 = await FlutterDownloader.enqueue(
//         url: 'https://research.nhm.org/pdfs/10840/10840-002.pdf',
//         headers: {},
//         // optional: header send with url (auth token etc)
//         savedDir: appDocPath,
//         saveInPublicStorage: true,
//         showNotification: true,
//         // show download progress in status bar (for Android)
//         openFileFromNotification:
//         false, // click on notification to open downloaded file (for Android)
//       );
//       log('taskID; $taskId $taskId2');
//     } catch (e) {
//       log('exception caught: $e');
//     }
//   }
//
//   // getProgress() async{
//   //   await FlutterDownloader.registerCallback((){
//   //
//   //   });
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     _port.listen((dynamic data) {
//       log('data: $data');
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];
//       log('progress: $progress');
//       setState(() {});
//     });
//
//     FlutterDownloader.registerCallback(downloadCallback);
//   }
//
//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//     super.dispose();
//   }
//
//   @pragma('vm:entry-point')
//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     final SendPort? send =
//     IsolateNameServer.lookupPortByName('downloader_send_port');
//     send!.send([id, status, progress]);
//     log('downloadCallback: $id $status $progress');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
