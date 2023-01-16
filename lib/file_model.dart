class FileModel {
  final String name, url;
  FileModel({required this.name, required this.url});
}

List<FileModel> dummyFileModel = [
  FileModel(
      name: 'file1',
      url:
          'https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_1MB_PDF.pdf'),
  FileModel(
      name: 'file2',
      url:
          'https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_100KB_PDF.pdf'),
  FileModel(
      name: 'file3',
      url:
          'https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data_2MB_MP4.mp4'),
  FileModel(name: 'file4', url: 'https://freetestdata.com/image-files/jpg/')
];
