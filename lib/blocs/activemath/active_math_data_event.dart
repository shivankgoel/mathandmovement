part of 'active_math_data_bloc.dart';

abstract class ActiveMathDataEvent extends Equatable {
  const ActiveMathDataEvent();
}

class GetAllActiveMathData extends ActiveMathDataEvent {
  @override
  List<Object> get props => [];
}
