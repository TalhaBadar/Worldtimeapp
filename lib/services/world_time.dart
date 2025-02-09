import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  String location; // location name for UI
  late String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  late bool isDaytime; // true or false if daytime or not

  WorldTime({ 
    required this.location, 
    required this.flag, 
    required this.url 
  });

  Future<void> getTime() async {
    try {
      // make the request
      final response = await http.get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map<String, dynamic> data = jsonDecode(response.body);

      // get properties from json
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      // set the time property
      isDaytime = now.hour > 6 && now.hour < 18 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('Error: $e');
      time = 'could not get time';
    }
  }
}
