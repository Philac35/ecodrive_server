extension StrExtension on String{


  /**
   * Function firstToUpperCase
   */
  firstToUpperCase() {
    if (startsWith(RegExp(r'[a-z]'))) {
      return "${substring(0, 1).toUpperCase()}${substring(1, length)}";
    }
  }

  /**
   * Function firstToLowerCase
   */
  firstToLowerCase() {
    if (this.startsWith(RegExp('[A-Z]'))) {
      return "${this.substring(0, 1).toLowerCase()}${this.substring(
          1, this.length)}";
    }




    /**
     * Function snakeToCamel
     */
    String snakeToCamel() {
      final reg = RegExp(r'_[a-z]');

      var result = replaceAllMapped(reg, (Match m) => m.group(0)!.toUpperCase());
      if (result.startsWith('A-Z')) {
        result = result.firstToLowerCase();
      }
      return result;
    }
  }

  /**
   * Function camelToSnake
   */
  String camelToSnake() {
    final reg = RegExp(r'[A-Z]');
    var result = replaceAllMapped(reg, (Match m) => '_${m.group(0)!.toLowerCase()}');
    if (result.startsWith('_')) {
      result = result.substring(1);
    }

    return result;
  }

  /**
   * Function replaceLast
   *  @Param RegExp regex
   *  @Param String replacement
   *  @Return String
   */
  String replaceLast(RegExp regex, String replacement){

    Iterable<Match>   matchStr=regex.allMatches(this);
    var lastMatchStr=matchStr.last;
    return this.replaceRange(lastMatchStr.start, lastMatchStr.end, replacement);
  }

  /**
   * Function replaceNieme
   *  @Param RegExp regex
   *  @Param int nieme element of Iterable RegExpMatch
   *  @Param String replacement
   *  @Return String
   */
  String replaceNieme(RegExp regex,int nieme, String replacement){
    Iterable<RegExpMatch>   matchStr=regex.allMatches(this);
    Iterable index=matchStr.indexed;
    final element=index.elementAt(nieme);
    return this.replaceRange(element.start, element.end, replacement);
  }


  /**
   * Function replaceNieme
   *  @Param RegExp regex
   *  @Param List nieme element
   *  @Param String replacement
   *  @Return String
   */
  String replaceNList(RegExp regex,List<int> niemeList, String replacement){
    String ret="";
    Iterable<Match>   matchStr=regex.allMatches(this);
    Iterable index=matchStr.indexed;

    for(var n in niemeList){
        final element=index.elementAt(n);
        ret=this.replaceRange(element.start, element.end, replacement);

    }
    return ret;
  }
}
