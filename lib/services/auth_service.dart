import 'package:google_sign_in/google_sign_in.dart';

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

