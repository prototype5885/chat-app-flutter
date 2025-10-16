import 'package:intl/intl.dart';

enum SnowflakeDateFormat { short, medium, long }

final epoch = BigInt.from(1420070400000);

String extractDate(String id, SnowflakeDateFormat format) {
  final BigInt bigId = BigInt.parse(id);
  final BigInt timestamp = (bigId >> 22) + epoch;
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());

  String pattern;

  switch (format) {
    case SnowflakeDateFormat.short:
      pattern = 'H:mm';
      break;
    case SnowflakeDateFormat.medium:
      pattern = 'MMMM d, y';
      break;
    case SnowflakeDateFormat.long:
      pattern = 'MMMM d, y HH:mm';
      break;
  }

  return DateFormat(pattern).format(date);
}
