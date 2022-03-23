import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mecanico_app/src/models/user.dart';
import 'package:mecanico_app/src/pages/home_page.dart';
import 'package:mecanico_app/src/utils/DatabaseService.dart';

class AuthProvider {
  FirebaseAuth _auth = FirebaseAuth.instance;

  UserApp _userFromFirebaseUser(User user) {
    return user != null ? UserApp(uid: user.uid) : null;
  }

  Stream<UserApp> get user {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  Future<bool> signInWithEmailAndPassword(
      String _email, String _password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      User user = result.user;
      if (user != null) {
        await DatabaseService().updateIsLoginUserData(user.uid, true);
        return true;
      } else
        return false;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser.uid != null) {
        String idUser = FirebaseAuth.instance.currentUser.uid.toString();
        await DatabaseService().updateIsLoginUserData(idUser, false);
      }
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } catch (e) {
      print("error logging out");
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) return false;
      final GoogleSignInAuthentication googleSignInAuthentication =
          await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential res = await _auth.signInWithCredential(credential);
      if (res.user == null) return false;
      var db = DatabaseService(uid: res.user.uid);
      if (!await db.usuarioEsxiste(res.user.uid)) {
        db.updateUsuarioData(new UserData(
            email: account.email,
            nombres: account.displayName,
            uid: res.user.uid));
      }
      await db.updateIsLoginUserData(res.user.uid, true);
      return true;
    } catch (e) {
      print(e.message);
      print("Error logging with google");
      return false;
    }
  }

  Future<GoogleUser> getGoogleInformation() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      return GoogleUser(
          id: account.id,
          email: account.email,
          fotoUrl: account.photoUrl,
          nombre: account.displayName);
    } catch (e) {
      print(e.message);
      print("Error logging to google");
      return null;
    }
  }

  // register with email and password
  Future<UserApp> registerWithEmailAndPassword(
      String _nombre, String _email, String _telefono, String _password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User user = result.user;
      // create a new document for the user with the uid
      var db = DatabaseService(uid: user.uid);
      await db.updateUsuarioData(UserData(
          uid: user.uid,
          email: _email,
          password: _password,
          nombres: _nombre,
          telefono: _telefono));
      db.updateIsLoginUserData(user.uid, true);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<bool> sendResetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }
}
