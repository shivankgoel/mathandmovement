part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();
}

class GetAllData extends DataEvent {
  @override
  List<Object> get props => [];
}
