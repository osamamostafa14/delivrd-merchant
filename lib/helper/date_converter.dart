import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime convertStringToDatetime2(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime convertStringToDatetimeLocal(String dateTime) {
   // DateFormat.yMEd().add_jms().format(dateTime);
    return DateFormat("yyyy-MM-dd").parse(dateTime);
  }
  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  // static String isoStringToLocalDateOnly(String dateTime) {
  //   return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  // }

  static String isoStringToLocalDateOnly(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  // static String localDateToIsoString(DateTime dateTime) {
  //   return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  // }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String localDateToHMString(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // static String convertTimeToTime(String time) {
  //   return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  // }

  static String convertTimeToTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

}
