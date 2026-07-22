// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String message(String name) {
    return 'Message $name';
  }

  @override
  String get today => 'Today';

  @override
  String todayAt(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.jm(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String yesterdayAt(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.jm(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Yesterday at $dateString';
  }

  @override
  String get error => 'Error';

  @override
  String get youAreNotSupposedToBeHere => 'You are not supposed to be here';

  @override
  String get checkingIfLoggedIn => 'Checking if logged in...';

  @override
  String get registration => 'Registration';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get passwordRepeat => 'Password repeat';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get register => 'Register';

  @override
  String get demo => 'Demo';

  @override
  String get requestingSession => 'Requesting session...';

  @override
  String get edit => 'Edit';

  @override
  String get copy => 'Copy';

  @override
  String get reply => 'Reply';

  @override
  String get delete => 'Delete';

  @override
  String get copyUserId => 'Copy User ID';

  @override
  String get copyServerId => 'Copy Server ID';

  @override
  String get copyChannelId => 'Copy Channel ID';

  @override
  String get copyMessageId => 'Copy Message ID';

  @override
  String get block => 'Block';

  @override
  String get unfriend => 'Unfriend';

  @override
  String get isTyping => ' is typing...';

  @override
  String get areTyping => ' are typing...';

  @override
  String get directMessages => 'Direct Messages';

  @override
  String get createServer => 'Create a Server';
}
