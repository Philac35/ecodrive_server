

class DateTimeLocal {
  DateTime? parseDate(String dateStr) {
    var ret;
    if (dateStr == null || dateStr.isEmpty) return null;
    dateStr = dateStr.contains('T') ? dateStr.split('T')[0] : dateStr;
    //print("DateTimeLocal L8 ${dateStr}");

    String lg = detectFormat(dateStr);

    try {
      try {
        DateTime? a = parseDateLg(dateStr, lg);
        print("DateTimeLocal L19, debug, parsedDate: ${a}");

        ret = a != null ? a : null;
      } catch (e, stack) {
        throw ("DateTimeLocal L20 , date error $e ; \\r\\n stack:$stack");
      }

      return ret;
    } catch (e) {
      print('Failed to parse date, error: $e');
      return null;
    }
  }

  /**
   * Function parseDateLg
   */
  DateTime? parseDateLg(String dateStr, String lang) {
    var day, month, year;
    var parts = dateStr.split(RegExp(r'[-/]'));

    if (parts.length != 3 || parts.contains(null)) return null;

    switch (lang) {
      case "fr":
        day = int.parse(parts[0]);
        month = int.parse(parts[1]);
        year = int.parse(parts[2]);
      case "en":
        day = int.parse(parts[2]);
        month = int.parse(parts[1]);
        year = int.parse(parts[0]);
    }

    return DateTime(year, month, day);
  }

  String detectFormat(String dateStr) {
    if (dateStr.contains(RegExp("^[0-9]{4}"))) {
      return 'en';
    } else {
      return 'fr';
    }
  }
}
