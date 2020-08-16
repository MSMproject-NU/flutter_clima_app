import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clima_app/utilities/constants.dart';
import 'package:flutter_clima_app/services/weather.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'city_screen.dart';

class LocationScreen extends StatefulWidget {

  final locationWeather;

  LocationScreen({this.locationWeather});


  
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  String weatherdescription;
  String windspeed;
  String sunrise_time;
  String sunset_time;
  String temp_min;
  String temp_max;
  String pressure;
  String humidity;
  
  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }


  String allWordsCapitilize (String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }

      var temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      cityName = weatherData['name'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      weatherdescription = weatherData["weather"][0]["description"];

      print(temperature);

      final f = new DateFormat('hh:mm a');

      sunrise_time = f.format(new DateTime.fromMillisecondsSinceEpoch(weatherData["sys"]["sunrise"]*1000));

      sunset_time = f.format(new DateTime.fromMillisecondsSinceEpoch(weatherData["sys"]["sunset"]*1000));

      windspeed = weatherData["wind"]["speed"].toString();

      print(weatherData["weather"][0]["description"]);

      print(weatherData['weather'][0]['id']);

      pressure = weatherData["main"]["pressure"].toString();

      humidity = weatherData["main"]["humidity"].toString();

      print(weatherData["sys"]["sunrise"]);

      print(weatherData["sys"]["sunset"]);

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF000046),
                const Color(0xFF1CB5E0),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(2.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.my_location,
                      size: 30.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                            }
                          ),
                        );
                        if (typedName != null) {
                          var weatherData = await weather.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                    child: Icon(
                      Icons.search,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100,),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        weatherIcon!="Error"?Text(
                          '$temperature° C',
                          style: kTempTextStyle,
                        ):Text(""),
                        Text(
                          weatherIcon,
                          style: kConditionTextStyle,
                        ),
                      ],
                    ),

                    weatherIcon!="Error"?Text(
                      allWordsCapitilize(weatherdescription),
                      style: kTempTextStyle,
                    ):Text(""),

                  ],
                ),
              ),

              SizedBox(height: 50,),
              Center(
                child:Text(
                    '$weatherMessage in $cityName!',
                    textAlign: TextAlign.center,
                    style: kMessageTextStyle,
                  ),
                ),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft:  Radius.circular(40)),
                              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                          ),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/wind.png",height: 50,width: 50,color: Colors.white,),
                              Text("Wind Speed"),
                              Text(windspeed),
                            ],
                          )),


                        ),

                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(

                              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                          ),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/pressure.png",height: 50,width: 50,color: Colors.white,),
                              Text("Pressure"),
                              Text(pressure),
                            ],
                          )),


                        ),

                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topRight:  Radius.circular(40)),
                              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                          ),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/humidity.png",height: 50,width: 50,color: Colors.white,),
                              Text("Humidity"),
                              Text(humidity),
                            ],
                          )),


                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(40)),
                              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                          ),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/sunrise.png",height: 50,width: 50,color: Colors.white,),
                              Text("Sunrise"),
                              Text(sunrise_time),
                            ],
                          )),


                        ),

                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(

                              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                          ),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/sunset.png",height: 50,width: 50,color: Colors.white,),
                              Text("Sunset"),
                              Text(sunset_time),
                            ],
                          )),


                        ),

                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight:  Radius.circular(40)),
                              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                          ),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info,color: Colors.white,size: 50,),
                              Text("Created by"),
                              Text("shimaayasser66"),
                            ],
                          )),


                        ),
                      ],
                    ),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}



