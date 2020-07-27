import 'package:equatable/equatable.dart';
import 'package:mathandmovement/blocs/user/bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class GetLoginInfoEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class GoogleLoginEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class EmailLoginEvent extends LoginEvent {
  String userEmail;
  String userPassword;
  EmailLoginEvent(this.userEmail, this.userPassword);
  @override
  List<Object> get props => [userEmail, userPassword];
}

class EmailSignUpEvent extends LoginEvent {
  String userName;
  String userEmail;
  String userPassword;
  EmailSignUpEvent(this.userName, this.userEmail, this.userPassword);
  @override
  List<Object> get props => [userName, userEmail, userPassword];
}
