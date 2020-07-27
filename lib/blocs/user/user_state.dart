import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class InitialUserState extends UserState {
  @override
  List<Object> get props => [];
}

class FetchingUserDataState extends UserState {
  @override
  List<Object> get props => [];
}

class UserDataLoadedState extends UserState {
  String userName;
  String userEmail;
  String userId;
  String userImage;
  UserDataLoadedState(
      this.userName, this.userEmail, this.userId, this.userImage);
  @override
  List<Object> get props => [userName, userEmail, userId, userImage];
}

class UserImageUpdatedState extends UserState {
  String userImage;
  UserImageUpdatedState(this.userImage);
  @override
  List<Object> get props => [userImage];
}
