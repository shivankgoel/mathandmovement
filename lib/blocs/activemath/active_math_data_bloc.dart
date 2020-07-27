import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'active_math_data_event.dart';
part 'active_math_data_state.dart';

class ActiveMathDataBloc
    extends Bloc<ActiveMathDataEvent, ActiveMathDataState> {
  ActiveMathDataBloc() : super(ActiveMathDataInitial());
  List _data = [];
  List get data => _data;

  @override
  Stream<ActiveMathDataState> mapEventToState(
    ActiveMathDataEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is GetAllActiveMathData) {
      yield ActiveMathDataInitial();
      QuerySnapshot snap = await Firestore.instance
          .collection("active_math_movement")
          .getDocuments();
      var x = snap.documents;
      _data.clear();
      x.forEach((f) {
        _data.add(f);
      });
      yield ActiveMathDataLoaded(_data);
    }
  }
}
