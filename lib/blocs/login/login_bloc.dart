import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mathandmovement/blocs/user/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialLoginState());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _name;
  String get name => _name;
  String _uid;
  String get uid => _uid;
  String _email;
  String get email => _email;
  String _imageUrl;
  String get imageUrl => _imageUrl;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  String timestamp;
  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
  }

  Future saveDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', _name);
    await sharedPreferences.setString('email', _email);
    await sharedPreferences.setString('uid', _uid);
    await sharedPreferences.setString('image url', _imageUrl);
    await sharedPreferences.setBool('signed in', true);
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);
    await ref.setData({
      'name': _name,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'timestamp': timestamp,
      'loved items': [],
      'bookmarked items': []
    });
  }

  Future getUserData(uid) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap.data['uid'];
      this._name = snap.data['name'];
      this._email = snap.data['email'];
      this._imageUrl = snap.data['image url'];
    });
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed in') ?? false;
  }

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GetLoginInfoEvent) {
      yield LoginStartState();
      final FirebaseUser user = await _firebaseAuth.currentUser();
      await this.getUserData(user.uid);
      await this.saveDataToSP();
      yield LoginCompleteState();
    }
    if (event is EmailLoginEvent) {
      try {
        yield LoginStartState();
        final FirebaseUser user =
            (await _firebaseAuth.signInWithEmailAndPassword(
                    email: event.userEmail, password: event.userPassword))
                .user;
        assert(user != null);
        assert(await user.getIdToken() != null);
        final FirebaseUser currentUser = await _firebaseAuth.currentUser();
        print(currentUser.uid);
        this.getUserData(currentUser.uid);
        this.saveDataToSP();
        yield LoginCompleteState();
      } catch (e) {
        print(e.toString());
        yield AuthErrorState("Invalid Credentials!");
      }
    }
    if (event is EmailSignUpEvent) {
      try {
        yield SignUpStartState();
        final FirebaseUser user =
            (await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.userEmail,
          password: event.userPassword,
        ))
                .user;
        assert(user != null);
        assert(await user.getIdToken() != null);
        this._name = event.userName;
        this._uid = user.uid;
        this._email = user.email;
        this._imageUrl = "";
        this.getTimestamp();
        this.saveDataToSP();
        this.saveToFirebase();
        yield SignUpCompleteState();
      } catch (e) {
        print(e.toString());
        yield AuthErrorState(e.message);
      }
    }
    if (event is GoogleLoginEvent) {
      yield LoginStartState();
      final GoogleSignIn _googlSignIn = new GoogleSignIn();
      final GoogleSignInAccount googleUser = await _googlSignIn
          .signIn()
          .catchError((error) => print('error : $error'));
      if (googleUser != null) {
        try {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          FirebaseUser userDetails =
              (await _firebaseAuth.signInWithCredential(credential)).user;

          this._name = userDetails.displayName;
          this._email = userDetails.email;
          this._imageUrl = userDetails.photoUrl;
          this._uid = userDetails.uid;
          yield LoginCompleteState();
        } catch (e) {
          print(e.code);
          yield AuthErrorState(e.toString());
        }
      } else
        yield AuthErrorState("Error Signing In via Google");
    }
    if (event is LogoutEvent) {
      FirebaseAuth.instance.signOut();
      yield InitialLoginState();
    }
  }
}
