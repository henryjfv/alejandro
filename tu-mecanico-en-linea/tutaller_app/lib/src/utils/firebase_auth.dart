import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutaller_app/src/models/user.dart';
import 'DatabaseService.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserApp _userFromFirebaseUser(User user) {
    return user != null ? UserApp(uid: user.uid) : null;
  }

  Stream<UserApp> get user {
    return _auth
        .authStateChanges()
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (user != null) {
        await DatabaseService(uid: user.uid)
            .updateIsLoginUserData(user.uid, true);
        return true;
      } else
        return false;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser.uid != null) {
        String idUser = FirebaseAuth.instance.currentUser.uid.toString();
        await DatabaseService(uid: idUser).updateIsLoginUserData(idUser, false);
      }
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }

  Future<int> loginWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if (account == null) return 0;
      final GoogleSignInAuthentication googleSignInAuthentication =
          await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      bool mecanico =
          await DatabaseService().usuarioMecanicoExiste(account.email);
      if (!mecanico) {
        bool taller =
            await DatabaseService().usuarioTallerExiste(account.email);
        if (!taller) {
          return -1;
        }
      }

      UserCredential res = await _auth.signInWithCredential(credential);
      if (res.user == null) return 0;

      String idUser = FirebaseAuth.instance.currentUser.uid.toString();
      await DatabaseService(uid: idUser).updateIsLoginUserData(idUser, true);

      return 1;
    } catch (e) {
      print(e.message);
      print("Error logging with google");
      return 0;
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

  Future<UserApp> registrarMecanico(UserMecanico mecanico) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: mecanico.email, password: mecanico.password);
      User user = result.user;
      mecanico.uid = user.uid;
      mecanico.isLogin = true;

      await DatabaseService(uid: user.uid).updateMecanicoData(mecanico);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<UserApp> registerTaller(UserTaller taller) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: taller.email, password: taller.password);
      User user = result.user;
      taller.uid = user.uid;
      taller.isLogin = true;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateTallerData(taller);
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
