import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]
);

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (e) {
    print('google sign in error: $e');
  }
}

Future<void> _handleSignOut() async {
  _googleSignIn.disconnect();
}