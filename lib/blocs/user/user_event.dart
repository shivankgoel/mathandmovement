import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetCurrentUserDataEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

class UpdateUserImageEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

class LoveIconClickEvent extends UserEvent {
  String timestamp;
  LoveIconClickEvent(this.timestamp);
  @override
  List<Object> get props => [timestamp];
}
