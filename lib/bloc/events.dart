abstract class FlightEvents{
  var content;
}

class GetLocationsEvent extends FlightEvents{}

class GetDealsEvent extends FlightEvents{}

class GetCitiesEvent extends FlightEvents{}

class SelectTypeEvent extends FlightEvents{}

class UnSelectTypeEvent extends FlightEvents{}

class InputLocationEvent extends FlightEvents{}

class SelectLocationEvent extends FlightEvents{}

//class SelectPageEvent extends FlightEvents{
//  SelectPageEvent(int index){
//    super.content = index;
//  }
//}
