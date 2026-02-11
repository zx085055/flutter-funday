class JsonHelper {
  JsonHelper._();

  /// serialize int (timestamp) to DateTime, default value is zero timestamp (1970/01/01 00:00:00)
  static DateTime timeFromTimestamp(String dateString) => DateTime.parse(dateString.replaceFirst(' +', '+'));

  /// serialize DateTime to int (timestamp), default value is zero
  static int timeToTimestamp(DateTime? time) => (time?.millisecondsSinceEpoch ?? 0) ~/ 1000;
}
