// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String message(String name) {
    return 'Üzenet $name';
  }

  @override
  String get today => 'Ma';

  @override
  String todayAt(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.jm(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get yesterday => 'Tegnap';

  @override
  String yesterdayAt(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.jm(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Tegnap $dateString';
  }

  @override
  String get error => 'Hiba';

  @override
  String get youAreNotSupposedToBeHere => 'Nem szabadna itt lenned';

  @override
  String get checkingIfLoggedIn => 'Bejelentkezési állapot ellenőrzése...';

  @override
  String get registration => 'Regisztráció';

  @override
  String get login => 'Bejelentkezés';

  @override
  String get username => 'Felhasználónév';

  @override
  String get password => 'Jelszó';

  @override
  String get passwordRepeat => 'Jelszó ismétlése';

  @override
  String get forgotPassword => 'Elfelejtette a jelszavát?';

  @override
  String get passwordsDontMatch => 'Jelszavak nem egyeznek meg';

  @override
  String get register => 'Regisztrálás';

  @override
  String get demo => 'Próba';

  @override
  String get requestingSession => 'Munkamenet kérése...';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get copy => 'Másolás';

  @override
  String get reply => 'Válasz';

  @override
  String get delete => 'Törlés';

  @override
  String get copyId => 'Azonosító Másolása';

  @override
  String get isTyping => ' gépel...';

  @override
  String get areTyping => ' gépel...';

  @override
  String get directMessages => 'Üzenetek';

  @override
  String get createServer => 'Szerver létrehozása';
}
