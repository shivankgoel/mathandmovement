part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();
}

class DataInitial extends DataState {
  @override
  List<Object> get props => [];
}

class DataLoaded extends DataState {
  List data;
  DataLoaded(this.data);
  @override
  List<Object> get props => [];
}
