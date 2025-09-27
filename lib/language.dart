class LanguageCode {
  static const String english = 'en';
  static const String german = 'de';
  static const String spanish = 'es';
  static const String french = 'fr';
}

Language lang = LanguageManager.getCurrentLanguage();

class Language {
  final String code;
  final String serverOffline;
  final String loggedIn;
  final String notLoggedIn;
  final String loggingIn;
  final String login;
  final String register;
  final String demo;
  final String enterEmail;
  final String enterPassword;
  final String enterPasswordAgain;
  final String loginFail;
  final String loginSuccess;
  final String rememberMe;
  final String editProfile;
  final String home;
  final String notifications;
  final String you;
  final String email;
  final String password;
  final String passwordAgain;
  final String loading;
  final String demoName;

  const Language({
    required this.code,
    required this.serverOffline,
    required this.loggedIn,
    required this.notLoggedIn,
    required this.loggingIn,
    required this.login,
    required this.register,
    required this.demo,
    required this.enterEmail,
    required this.enterPassword,
    required this.enterPasswordAgain,
    required this.loginFail,
    required this.loginSuccess,
    required this.rememberMe,
    required this.editProfile,
    required this.home,
    required this.notifications,
    required this.you,
    required this.email,
    required this.password,
    required this.passwordAgain,
    required this.loading,
    required this.demoName,
  });
}

const List<Language> languages = [
  Language(
    code: LanguageCode.english,
    serverOffline: 'Server is offline.',
    loggedIn: 'Logged in!',
    notLoggedIn: 'Not logged in!',
    loggingIn: 'Logging in...',
    login: 'Login',
    register: 'Register',
    demo: 'Demo',
    enterEmail: 'Enter your e-mail address',
    enterPassword: 'Enter your password',
    enterPasswordAgain: 'Enter your password again',
    loginFail: 'Login failed!',
    loginSuccess: 'Successful login!',
    rememberMe: 'Remember me',
    editProfile: 'Edit profile',
    home: 'Home',
    notifications: 'Notifications',
    you: 'You',
    email: 'Email',
    password: 'Password',
    passwordAgain: 'Password again',
    loading: 'Loading...',
    demoName: 'Demo name',
  ),
];

class LanguageManager {
  static String _currentLanguageCode = LanguageCode.english;

  static Language getCurrentLanguage() {
    try {
      return languages.firstWhere((lang) => lang.code == _currentLanguageCode);
    } catch (e) {
      return languages.firstWhere((lang) => lang.code == LanguageCode.english);
    }
  }

  static void setLanguage(String code) {
    if (languages.any((lang) => lang.code == code)) {
      _currentLanguageCode = code;
    }
  }
}
