import 'package:download_background/file_model.dart';

class DownloadEvent {
  final int progress;
  final int id;

  DownloadEvent(this.progress, this.id);
}


class AddedToQueue {
  final FileModel fileModel;
  AddedToQueue(this.fileModel);
}


class Download {
  final FileModel fileModel;
  Download(this.fileModel);
}

class DownloadComplete {
  final FileModel fileModel;
  DownloadComplete(this.fileModel);
}

class Downloading {
  final FileModel fileModel;
  final String progress;
  Downloading(this.fileModel, this.progress);
}

///if both files are clicked to be downloaded in such a way that as one completes then click for second to download, then it is saving