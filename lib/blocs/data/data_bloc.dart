import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataInitial());

  List _data = [];
  List get data => _data;

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is GetAllData) {
      yield DataInitial();
      QuerySnapshot snap = await Firestore.instance
          .collection('materials/grade1/activity')
          .getDocuments();
      var x = snap.documents;
      _data.clear();
      x.forEach((f) {
        _data.add(f);
      });
      yield DataLoaded(_data);
    }
  }
}
