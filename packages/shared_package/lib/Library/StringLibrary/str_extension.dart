extension StrExtension on String{

  firstToLowerCase() {
    if (this.startsWith('A-Z')) {
      return "${this.substring(0, 1).toLowerCase()}${this.substring(
          1, this.length)}";
    }

    firstToUpperCase() {
      if (startsWith('A-Z')) {
        return "${substring(0, 1).toUpperCase()}${substring(
            1, length)}";
      }
    }


    String snakeToCamel() {
      final reg = RegExp(r'_[a-z]');

      var result = replaceAllMapped(reg, (Match m) => '${m.group(0)!.toUpperCase()}');
      if (result.startsWith('A-Z')) {
        result = result.firstToLowerCase();
      }
      return result;
    }
  }

  String camelToSnake() {
    final reg = RegExp(r'[A-Z]');
    var result = replaceAllMapped(reg, (Match m) => '_${m.group(0)!.toLowerCase()}');
    if (result.startsWith('_')) {
      result = result.substring(1);
    }
    return result;
  }

}
