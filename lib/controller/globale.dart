import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const String defaultImage = "http://cdn.onlinewebfonts.com/svg/img_569204.png";

String currentPage = "";

String timestampToHumanReadable(Timestamp timestamp) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
  var formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  return formatter.format(dateTime);
}
