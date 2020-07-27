part of 'active_math_data_bloc.dart';

abstract class ActiveMathDataState extends Equatable {
  const ActiveMathDataState();
}

class ActiveMathDataInitial extends ActiveMathDataState {
  @override
  List<Object> get props => [];
}

class ActiveMathDataLoaded extends ActiveMathDataState {
  List data;
  ActiveMathDataLoaded(this.data);
  @override
  List<Object> get props => [];
}
