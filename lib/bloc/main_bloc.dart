import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import '../api/firebase_services.dart';
import '../model/flight_deals.dart';
import '../model/city.dart';

class MainBloc {
  FirebaseService firebaseService;
  int _selectedPopupItemIndex = 0;
  int _selectedPageIndex = 0;
  bool _isFlightSelected = true;
  String _textFieldContent = '';
  List<String> _locations = ['None'];
  List<City> _cities = [];
  List<FlightDeals> _deals = [];

  // App state Controller, Streams and Sinks
  final _selectedLocationController = BehaviorSubject<int>();
  final _selectedTypeController = BehaviorSubject<bool>();
  final _inputLocationEvent = BehaviorSubject<String>();
  final _selectedPageController = BehaviorSubject<int>();

  final _flightEventsController = StreamController<FlightEvents>();

  StreamSink<int> get _selectedPopupItemIndexSink =>
      _selectedLocationController.sink;
  Stream<int> get selectedPopupItemIndex => _selectedLocationController.stream;

  StreamSink<int> get _selectedPageSink => _selectedPageController.sink;
  Stream<int> get selectedPageIndex => _selectedPageController.stream;

  StreamSink<bool> get _isFlightSelectedSink => _selectedTypeController.sink;
  Stream<bool> get isFlightSelected => _selectedTypeController.stream;

  StreamSink<String> get _textFieldContentSink => _inputLocationEvent.sink;
  Stream<String> get textFieldContent => _inputLocationEvent.stream;

  Sink<FlightEvents> get flightEventSink => _flightEventsController.sink;

  // Firebase Controllers and Sinks
  final _getLocationsController = BehaviorSubject<List<String>>();
  final _getCitiesController = BehaviorSubject<List<City>>();
  final _getDealsController = BehaviorSubject<List<FlightDeals>>();

  StreamSink<List<String>> get _locationsSink => _getLocationsController.sink;

  Stream<List<String>> get locations => _getLocationsController.stream;

    StreamSink<List<City>> get _citiesSink => _getCitiesController.sink;

    Stream<List<City>> get cities => _getCitiesController.stream;

    StreamSink<List<FlightDeals>> get _dealsSink => _getDealsController.sink;

    Stream<List<FlightDeals>> get deals{

      return _getDealsController.stream;
    }

    MainBloc() {
      _selectedPageSink.add(_selectedPageIndex);
      firebaseService = FirebaseService();
      firebaseService.getCities().listen(
              (event) => _handleFirebaseEvents(event.documents, GetCitiesEvent()));
      firebaseService.getDeals().listen(
              (event) => _handleFirebaseEvents(event.documents, GetDealsEvent()));
      firebaseService.getLocations().listen(
              (event) => _handleFirebaseEvents(event.documents, GetLocationsEvent()));
      _flightEventsController.stream.listen(_handleFlightEvents);
    }

    _handleFirebaseEvents(
        List<DocumentSnapshot> snapshot, FlightEvents eventType) {
      switch(eventType.runtimeType){
        case GetCitiesEvent:
          _cities.clear();
          for(int i = 0; i < snapshot.length; i++){
            _cities.add(City.fromSnapshots(snapshot[i]));
          }
          _citiesSink.add(_cities);
          break;
        case GetLocationsEvent:
          _locations.clear();
          _locations.addAll(List<String>.from(snapshot[0].data['list']));
          _locationsSink.add(_locations);
          break;
        case GetDealsEvent:
          _deals.clear();
          for(int i = 0; i < snapshot.length; i++){
            _deals.add(FlightDeals.fromSnapshot(snapshot[i]));
          }
          _dealsSink.add(_deals);
          break;
      }
    }

    _handleFlightEvents(FlightEvents events) {
      switch (events.runtimeType) {
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
        case SelectPageEvent:
          _selectedPageIndex = events.content;
          _selectedPageSink.add(_selectedPageIndex);
          break;
      }
    }

    void dispose() {
      _selectedLocationController.close();
      _selectedTypeController.close();
      _inputLocationEvent.close();
      _flightEventsController.close();
      _getCitiesController.close();
      _getDealsController.close();
      _getLocationsController.close();
      _selectedPageController.close();
    }
  }
