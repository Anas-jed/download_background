class FileModel {
  final String name, url, ext;
  FileModel({required this.name, required this.url, required this.ext});
}

List<FileModel> dummyFileModel = [
  FileModel(
      name: 'file1',
      url:
          'https://freetestdata.com/wp-content/uploads/2021/09/Free_Test_Data_1MB_PDF.pdf',
      ext: 'pdf'),
  FileModel(
      name: 'file2',
      url:
          'https://effigis.com/wp-content/uploads/2015/02/DigitalGlobe_WorldView2_50cm_8bit_Pansharpened_RGB_DRA_Rome_Italy_2009DEC10_8bits_sub_r_1.jpg',
      ext: 'jpg'),
  FileModel(
      name: 'file3',
      url:
          'https://file-examples.com/storage/fe63486cdb63c429195a385/2017/04/file_example_MP4_1280_10MG.mp4',
      ext: 'mp4'),
  FileModel(
      name: 'file4',
      url:
          'https://file-examples.com/storage/fe63486cdb63c429195a385/2017/11/file_example_MP3_5MG.mp3',
      ext: 'mp3')
];
