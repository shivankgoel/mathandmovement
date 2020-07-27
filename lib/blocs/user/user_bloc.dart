import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(InitialUserState());
  String _userName = 'Name';
  String _email = 'email';
  String _uid = 'uid';
  String _imageUrl =
      'http://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png';
  String get userName => _userName;
  String get userEmail => _email;
  String get userId => _uid;
  String get userImage => _imageUrl;

  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _userName = sp.getString('name');
    _email = sp.getString('email');
    _uid = sp.getString('uid');
    _imageUrl = sp.getString('image url');
//    print("UserBloc is getting Data From SP");
//    print(_userName + " " + _email + " " + _uid + " " + _imageUrl);
  }

  @override
  UserState get initialState => InitialUserState();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetCurrentUserDataEvent) {
      yield FetchingUserDataState();
      await this.getUserData();
      yield UserDataLoadedState(_userName, _email, _uid, _imageUrl);
    }
    if (event is LoveIconClickEvent) {
      final DocumentReference ref =
          Firestore.instance.collection('users').document(_uid);
      final DocumentReference ref1 =
          Firestore.instance.collection('contents').document(event.timestamp);
      DocumentSnapshot snap = await ref.get();
      DocumentSnapshot snap1 = await ref1.get();
      List d = snap.data['loved items'];
      int num_loves = snap1['loves'];

      if (d.contains(event.timestamp)) {
        List a = [event.timestamp];
        await ref.updateData({'loved items': FieldValue.arrayRemove(a)});
        ref1.updateData({'loves': num_loves - 1});
      } else {
        d.add(event.timestamp);
        await ref.updateData({'loved items': FieldValue.arrayUnion(d)});
        ref1.updateData({'loves': num_loves + 1});
      }
    }
    if (event is UpdateUserImageEvent) {
      //Update on server
      final DocumentReference ref =
          Firestore.instance.collection('users').document(_uid);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(_uid)
          .child('image');
      ImagePicker _picker = ImagePicker();
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      await storageRef.putFile(File(pickedFile.path)).onComplete;
      final profileurl = await storageRef.getDownloadURL();
      ref.updateData({'image url': profileurl});

      //Update in App
      final SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString('image url', profileurl);
      this._imageUrl = profileurl;
      yield UserDataLoadedState(_userName, _email, _uid, profileurl);
    }
  }
}
