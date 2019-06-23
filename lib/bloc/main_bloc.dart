import 'dart:async';
import 'package:flutter/material.dart';

import 'events.dart';


class MainBloc {
  int _selectedPopupItemIndex = 0;
  bool _isFlightSelected = true;
  String _textFieldContent = '';

  final _selectedLocationController = StreamController<int>();
  final _selectedTypeController = StreamController<bool>();
  final _inputLocationEvent = StreamController<String>();

  final _flightEventsController = StreamController<FlightEvents>();

  StreamSink<int> get _selectedPopupItemIndexSink => _selectedLocationController.sink;
  Stream<int> get selectedPopupItemIndex => _selectedLocationController.stream;

  StreamSink<bool> get _isFlightSelectedSink => _selectedTypeController.sink;
  Stream<bool> get isFlightSelected => _selectedTypeController.stream;

  StreamSink<String> get _textFieldContentSink => _inputLocationEvent.sink;
  Stream<String> get textFieldContent => _inputLocationEvent.stream;

  Sink<FlightEvents> get flightEventSink => _flightEventsController.sink;

  MainBloc() {
    _flightEventsController.stream.listen(_handleFlightEvents);
  }

  _handleFlightEvents(FlightEvents events){
    switch(events.runtimeType){
      case SelectTypeEvent:
        _isFlightSelected = true;
        _isFlightSelectedSink.add(_isFlightSelected);
        break;
      case UnSelectTypeEvent:
        _isFlightSelected = false;
        _isFlightSelectedSink.add(_isFlightSelected);
        break;
      case SelectLocationEvent:
        _selectedPopupItemIndex = events.content;
        _selectedPopupItemIndexSink.add(_selectedPopupItemIndex);
        break;
      case InputLocationEvent:
        _textFieldContent = events.content;
        _textFieldContentSink.add(_textFieldContent);
        break;
    }
  }

  void dispose() {
    _selectedLocationController.close();
    _selectedTypeController.close();
    _inputLocationEvent.close();
    _flightEventsController.close();
  }
}