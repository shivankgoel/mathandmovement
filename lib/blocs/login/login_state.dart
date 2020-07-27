import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginStartState extends LoginState {
  @override
  List<Object> get props => [];
}

class SignUpStartState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginProgressState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginCompleteState extends LoginState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends LoginState {
  String message;
  AuthErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class SignUpCompleteState extends LoginState {
  @override
  List<Object> get props => [];
}
