import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseService() {
    initFirebase();
  }

  initFirebase() async {
    FirebaseApp app = await FirebaseApp.configure(
      name: 'flight-app',
      options: Platform.isIOS
          ? const FirebaseOptions(
              googleAppID: '1:209246495743:ios:192ddf177e552326',
              gcmSenderID: '209246495743',
              databaseURL: 'https://flight-app-11ff1.firebaseio.com/',
            )
          : const FirebaseOptions(
              googleAppID: '1:209246495743:android:bcf85e5019f93292',
              apiKey: 'AIzaSyC-91FlUFywLE2th6hWAXbroCTCNtwpB24',
              databaseURL: 'https://flight-app-11ff1.firebaseio.com/',
            ),
    );
  }

  Stream<QuerySnapshot> getLocations() => Firestore.instance.collection('locations').snapshots();

  Stream<QuerySnapshot> getCities() => Firestore.instance.collection('cities').snapshots();

  Stream<QuerySnapshot> getDeals() => Firestore.instance.collection('deals').snapshots();
}
