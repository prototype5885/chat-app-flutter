import 'package:chat_app_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int extractTimestamp(int id) {
  const epoch = 1772841600;
  const timeshift = 22;
  return (id >> timeshift) + epoch;
}

String editedTimestamp(int timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(
    timestamp * 1000,
  ).toLocal();
  return DateFormat.yMd().add_jm().format(dateTime);
}

String getDate(BuildContext context, int id) {
  final timestamp = extractTimestamp(id);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final diff = today.difference(day).inDays;

  if (diff == 0) {
    return AppLocalizations.of(context)!.todayAt(dateTime);
  } else if (diff == 1) {
    return AppLocalizations.of(context)!.yesterdayAt(dateTime);
  } else {
    return DateFormat.yMd().add_jm().format(dateTime);
  }
}

String getDayDate(BuildContext context, int id) {
  final timestamp = extractTimestamp(id);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final diff = today.difference(day).inDays;

  if (diff == 0) {
    return AppLocalizations.of(context)!.today;
  } else if (diff == 1) {
    return AppLocalizations.of(context)!.yesterday;
  } else {
    return DateFormat.yMd().format(dateTime);
  }
}

String getShortDate(int id) {
  final timestamp = extractTimestamp(id);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  return DateFormat.Hm().format(dateTime);
}

bool isSameDay(int currentId, int nextId) {
  final c = DateTime.fromMillisecondsSinceEpoch(extractTimestamp(currentId));
  final n = DateTime.fromMillisecondsSinceEpoch(extractTimestamp(nextId));
  return (c.year == n.year && c.month == n.month && c.day == n.day);
}

bool isOlderThanFiveMins(int currentId, int nextId) {
  final c = extractTimestamp(currentId);
  final n = extractTimestamp(nextId);

  final difference = n - c;

  return difference > 300_000; // 5 mins in ms
}
