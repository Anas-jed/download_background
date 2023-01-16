class DownloadEvent {
  final int progress;
  final int id;

  DownloadEvent(this.progress,this.id);
}

///if both files are clicked to be downloaded in such a way that as one completes then click for second to download, then it is saving