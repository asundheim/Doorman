import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignInAccount currentUser;

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]
);

Future<void> handleSignIn() async {
  try {
    await googleSignIn.signIn();
  } catch (e) {
    print('google sign in error: $e');
  }
}

Future<void> handleSignOut() async {
  googleSignIn.disconnect();
}

bool loginExists(SharedPreferences prefs) =>
    prefs.getKeys().contains('authToken') && prefs.getKeys().contains('userID');

String getUserID(SharedPreferences prefs) =>
    prefs.getString('userID');

String getAuthToken(SharedPreferences prefs) =>
    prefs.getString('authToken');
