import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eticket/constantes/Constante.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:eticket/constantes/LoadingWidget.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'SecondPage.dart';
import 'WishList.dart';
import 'Deals.dart';
import 'Notifications.dart' as not;

void main() {
  runApp(const MyApp());
}

ThemeData appTheme = ThemeData(
    primaryColor: Colors.purple,
    /* Colors.tealAccent,*/
    secondaryHeaderColor: Colors.blue /* Colors.teal*/
    // fontFamily:
    );
int sel = 0;
double? width = 450;
double? height = 350;
final bodies = [
  MyHomePage(title: 'Mon tp'),
  WishList(),
  Deals(),
  not.Notification(),
];

class BottomNav extends StatefulWidget {
  BottomNav({Key? key}) : super(key: key);

  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<BottomNavigationBarItem> createItems() {
    List<BottomNavigationBarItem> items = [];
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.home,
          color: Colors.black,
        ),
        label: "Accueil"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.airlines,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.airlines,
          color: Colors.black,
        ),
        label: "Mon ticket"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.car_rental_rounded,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.car_rental_rounded,
          color: Colors.black,
        ),
        label: "Compagnies & Gares"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.notifications,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.notifications,
          color: Colors.black,
        ),
        label: "Notifications"));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bodies.elementAt(sel),
        bottomNavigationBar: BottomNavigationBar(
          items: createItems(),
          unselectedItemColor: Colors.black,
          selectedItemColor: appTheme.primaryColor,
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          currentIndex: sel,
          elevation: 1.5,
          onTap: (int index) {
            if (index != sel)
              setState(() {
                sel = index;
              });
          },
        ));
  }
}

var selectedloc = 0;

class HomeTop extends StatefulWidget {
  @override
  _HomeTop createState() => _HomeTop();
}

class _HomeTop extends State<HomeTop> {
  var isFlightselected = true;
  TextEditingController c = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: Clipper08(),
          child: Container(
            padding: EdgeInsets.all(38.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              appTheme.primaryColor,
              appTheme.secondaryHeaderColor
            ])),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: height! / 16,
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.local_car_wash,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: width! * 0.05,
                      ),
                      Spacer(),
                      Icon(
                        Icons.settings,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: height! / 16,
                // ),
                Text(
                  'Acheter vos tickets à distance',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height! * 0.0375),
                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: TextField(
                      controller: c,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                          labelText: 'Rechercher votre ticket ici..',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 13),
                          suffixIcon: Material(
                            child: InkWell(
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            not.Notification()));
                              },
                            ),
                            elevation: 2.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: height! * 0.025,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      child: Choice08(
                          icon: Icons.flight_takeoff,
                          text: "Flights",
                          selected: isFlightselected),
                      onTap: () {
                        setState(() {
                          isFlightselected = true;
                        });
                      },
                    ),
                    SizedBox(
                      width: width! * 0.055,
                    ),
                    InkWell(
                      child: Choice08(
                          icon: Icons.hotel,
                          text: "Hotels",
                          selected: !isFlightselected),
                      onTap: () {
                        setState(() {
                          isFlightselected = false;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Clipper08 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);
    // ignore: non_constant_identifier_names
    var End = Offset(size.width / 2, size.height - 30.0);
    // ignore: non_constant_identifier_names
    var Control = Offset(size.width / 4, size.height - 50.0);

    path.quadraticBezierTo(Control.dx, Control.dy, End.dx, End.dy);
    // ignore: non_constant_identifier_names
    var End2 = Offset(size.width, size.height - 80.0);
    // ignore: non_constant_identifier_names
    var Control2 = Offset(size.width * .75, size.height - 10.0);

    path.quadraticBezierTo(Control2.dx, Control2.dy, End2.dx, End2.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.purple, secondaryHeaderColor: Colors.blue),
      home: BottomNav(),
    );
  }
}

class Choice08 extends StatefulWidget {
  final IconData? icon;
  final String? text;
  final bool? selected;
  Choice08({this.icon, this.text, this.selected});
  @override
  _Choice08State createState() => _Choice08State();
}

class _Choice08State extends State<Choice08>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: widget.selected!
          ? BoxDecoration(
              color: Colors.white.withOpacity(.30),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: width! * .025,
          ),
          Text(
            widget.text!,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool loading = false;
  String? select1;
  String? select2;
  String _date = '';
  List destinations = ["eeee"];
  List departs = [];
  TextEditingController _datecontroller = TextEditingController();

  void destinationsList() async {
    setState(() {
      loading = true;
    });
    String url = APIconstante.apiURL + "villes";
    try {
      Uri uri = Uri.parse(url);
      var response = await http.get(uri);
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        // print(response.body);
        var responseBody = jsonDecode(response.body);
        if (responseBody['status']) {
          setState(() {
            destinations = responseBody['data'];
            loading = false;
          });
          // print('avant');
          // print(destinations);
        } else {
          Alert(
            context: context,
            title: "Attention",
            desc: "Une erreur s'est produite.",
          ).show();

          setState(() {
            loading = true;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _tarif() async {
    setState(() {
      loading = true;
    });
    if (_date == '') {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Attention",
        desc: "Veuillez choisir une date",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
      setState(() {
        loading = false;
      });
    } else {
      String url = APIconstante.apiURL + "get-tarifs-compagnie";
      try {
        Uri uri = Uri.parse(url);
        // var response = await http.get(uri);

        var response = await http
            .post(uri, body: {'departId': select1, 'arriveId': select2});
        int statusCode = response.statusCode;
        if (statusCode == 200) {
          // print(response.body);
          var responseBody = jsonDecode(response.body);
          if (responseBody['status']) {
            setState(() {
              departs = responseBody['data'];
              loading = false;
            });
            var length = responseBody['data'].length;
            print('avant' + length.toString());
            if (length > 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SecondPage(
                          departs: departs,
                          date: _date,
                          fromloc: departs[0]['arrivev']['name'],
                          toloc: departs[0]['departv']['name'])));
            } else {
              Alert(
                  context: context,
                  type: AlertType.info,
                  title: "Attention",
                  desc: "Il n'y a pas de voyage pour ce trajet",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                      width: 120,
                    )
                  ]).show();
            }
            // print('avant');
            // print(destinations);
          } else {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Attention",
              desc: "Une erreur s'est produite.",
              buttons: [
                DialogButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();

            setState(() {
              loading = true;
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future _select_full_date() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2025));

    if (picker != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(picker);
        _datecontroller.text = _date;
      });
    } else {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Attention",
        desc: "Veuillez choisir une date",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _counter = 40;
    super.initState();
    destinationsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      backgroundColor: appTheme.primaryColor.withOpacity(.5),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            HomeTop(),
            Container(
              child: Center(
                child: loading
                    ? LoadingWidget.SmallLoading()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  'Départ : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DropdownButton(
                                  icon: Icon(Icons.pin_drop_outlined),
                                  value: select1,
                                  elevation: 10,
                                  items: destinations.map((item) {
                                    return DropdownMenuItem<String>(
                                        child: Text(item['name']),
                                        value: item['id'].toString());
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      select1 = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  'Arrivé : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DropdownButton(
                                  icon: Icon(Icons.pin_drop_outlined),
                                  value: select2,
                                  elevation: 10,
                                  items: destinations.map((item) {
                                    return DropdownMenuItem<String>(
                                        child: Text(item['name']),
                                        value: item['id'].toString());
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      select2 = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Center(
                              child: Container(
                            width: 180,
                            child: TextField(
                                controller: _datecontroller,
                                onTap: _select_full_date,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  labelText: 'Date de départ',
                                )),
                          )),
                          Center(
                              child: Container(
                            padding:
                                EdgeInsets.only(left: 16, top: 25, right: 16),
                            child: ElevatedButton(
                                onPressed: _tarif, child: Text('Rechercher')),
                          ))
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
