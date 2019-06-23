import 'package:flutter/material.dart';
import 'main_bloc.dart';

class InheritedFlightApp extends InheritedWidget {
  final MainBloc bloc;

  InheritedFlightApp({Widget child, this.bloc}) : super(child: child);

  static InheritedFlightApp of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedFlightApp);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
