import 'dart:io';

extension FilePathExtension on File{

  /**
   * Function fileName
   */
  fileName() {
    return  this.path.split('/').last;
  }

  fileExtension(){
    return this.fileName().split('.').last;
  }



}


