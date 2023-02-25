import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart' as prefix0;
import 'main.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:eticket/constantes/Constante.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'dart:async';
import 'package:eticket/constantes/LoadingWidget.dart';

final Color discountBackground = prefix0.appTheme.primaryColor;
final Color flightColor = prefix0.appTheme.primaryColor;
final Color chipBackground =
    prefix0.appTheme.secondaryHeaderColor.withOpacity(.2);
final Color borderColor = prefix0.appTheme.primaryColor.withAlpha(100);
String? fromlocation;
String? tolocation;

class SecondPage extends StatefulWidget {
  final departs;
  final date;
  final String? fromloc;
  final String? toloc;
  SecondPage({Key? key, this.fromloc, this.toloc, this.departs, this.date})
      : super(key: key);
  @override
  _SecondPage createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {
  @override
  List eventsTest = [];
  List gares = [];
  List departsH = [];
  bool loading = false;
  Uri _url = Uri.parse('https://flutter.dev');
  String? gareselected = '';
  String? tarifId;
  String? departId;
  String? garename = 'gare';
  TextEditingController name = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController nb_ticket = TextEditingController();

  void initState() {
    super.initState();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _getDepart() async {
    try {
      setState(() {
        loading = true;
      });
      String url =
          APIconstante.apiURL + "departs-gare/" + gareselected.toString();
      Uri uri = Uri.parse(url);
      var response = await http.get(uri, headers: APIconstante.apiHEADERS);

      // sample info available in response
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['status']) {
          departsH = responseBody['data'];
          loading = false;
          // Navigator.pop(context);
          // _formulaire();
          print('departsH' + departsH.toString());
        } else {}
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  void _payer() async {
    setState(() {
      loading = true;
    });
    String url = APIconstante.apiURL + "voyages";
    try {
      Uri uri = Uri.parse(url);
      print('name:' + name.text.toString());
      print('numero:' + numero.text.toString());
      print('date:' + widget.date.toString());
      print('nb_ticket:' + nb_ticket.text.toString());
      print('tarif_id:' + tarifId.toString());
      print('depart_id:' + departId.toString());
      print('gare_id:' + gareselected.toString());

      var response = await http.post(uri, body: {
        'name': name.text,
        'numero': numero.text,
        'date': widget.date,
        'nb_ticket': nb_ticket.text,
        'tarif_id': tarifId.toString(),
        'depart_id': departId.toString(),
        'gare_id': gareselected.toString(),
      });
      int statusCode = response.statusCode;
      print('avant' + response.body.toString());
      if (statusCode == 200) {
        // print(response.body);
        var responseBody = jsonDecode(response.body);

        if (responseBody['status']) {
          setState(() {
            _url = Uri.parse(responseBody['data']['wave_launch_url']);
            loading = false;
            _launchUrl();
            Navigator.pop(context);
            Alert(
              context: context,
              type: AlertType.info,
              title: "Paiement",
              desc:
                  "Veuillez effectuer le paiement via le SMS que vous avez reçu",
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
          });
        } else {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "Attention",
            desc: responseBody['message'],
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
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _formulaire() async {
    await Alert(
        context: context,
        title: "Renseignez vos informations",
        closeIcon: Icon(Icons.close),
        content: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Nom & prenoms',
              ),
            ),
            TextField(
              controller: numero,
              decoration: const InputDecoration(
                icon: Icon(Icons.call),
                labelText: 'Contact',
              ),
            ),
            TextField(
              controller: nb_ticket,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Nombre de place',
              ),
            ),
            Row(
              children: [
                const Icon(Icons.location_city),
                const Padding(padding: EdgeInsets.only(left: 16.0, top: 16)),
                DropdownButton(
                  value: gareselected,
                  elevation: 20,
                  hint: Text('Gare'),
                  items: gares.map((item) {
                    return DropdownMenuItem<String>(
                        child: Text(item['name']),
                        value: item['id'].toString());
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      gareselected = value!;
                      print(gareselected);
                      _getDepart();
                      // Navigator.pop(context);
                      // _formulaire();
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.lock_clock),
                const Padding(padding: EdgeInsets.only(left: 16.0, top: 16)),
                DropdownButton(
                  value: departId,
                  elevation: 10,
                  hint: const Text('Heure de depart'),
                  items: departsH.map((item) {
                    return DropdownMenuItem<String>(
                        child: Text(item['heure']),
                        value: item['id'].toString());
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      departId = value;
                      // gareselected = value!;
                      print(departId);
                      // Navigator.pop(context);
                      // _formulaire();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: _payer,
            child: const Text(
              "Payer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    fromlocation = widget.fromloc;
    tolocation = widget.toloc;
    // print('sssss' + widget.departs.toString());

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Tarifs des voyages',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[StackTop(), StackDown(context)],
          ),
        ));
  }

  Widget StackDown(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Comparez les coûts',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: widget.departs!.map<Widget>((e) {
                return FlightCard(
                    widget.date,
                    e['compagnie']['name'].toString(),
                    e['cout'].toString(),
                    e['id'].toString(),
                    e['arrivev']['name'],
                    e['compagnie']['gares'],
                    'https://eticket.lce-ci.com/public/' +
                        e['compagnie']['logo'].toString());
              }).toList(),
            )
          ],
        ));
  }

  Widget FlightCard(
      date, compagnie, price, rating, flightTo, List gare, image) {
    return InkWell(
      onTap: () {
        setState(() {
          gares = gare;
          gareselected = null;
          departId = null;
          _formulaire();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                //height: prefix0.height/6,

                width: prefix0.width! * .8,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.lerp(
                      Radius.elliptical(10, 20), Radius.circular(20), 2)!),
                  border: Border.all(color: borderColor),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Tag(
                          label: price.toString() + ' Fcfa',
                          avatar: Icon(Icons.attach_money, size: 18),
                        ),
                        SizedBox(
                          width: prefix0.width! * .02,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: prefix0.height! * .03,
                    ),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: -5.0,
                      children: <Widget>[
                        Tag(
                          label: date,
                          avatar: Icon(
                            Icons.calendar_today,
                            size: 18,
                          ),
                        ),
                        Tag(
                          label: flightTo!,
                          avatar: Icon(Icons.wallet_travel, size: 18),
                        ),
                        Tag(
                          label: rating.toString(),
                          avatar: Icon(Icons.money, size: 18),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                top: prefix0.height! * .025,
                right: 15,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  width: prefix0.width! * .09,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: discountBackground.withOpacity(.8)),
                  child: Center(
                    child: Text(
                      compagnie,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  String? label;
  Widget? avatar;

  Tag({this.avatar, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: RawChip(
        label: Text(
          label!,
        ),
        labelStyle: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
        avatar: avatar,
        backgroundColor: chipBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}

class StackTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Key from;
    // Key to;
    return Material(
      elevation: 0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: Clipper08(),
            child: Container(
              height: height! * .272, //400
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appTheme.primaryColor,
                    appTheme.primaryColor.withAlpha(240)
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: prefix0.height! * .04,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                margin:
                    EdgeInsets.symmetric(horizontal: prefix0.height! * .035),
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(prefix0.height! * .035),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(Icons.pin_drop_outlined),
                                Text(
                                  tolocation!,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('(départ)'),
                              ],
                            ),
                            Divider(
                              color: Colors.black12,
                              height: prefix0.height! * .04,
                            ),
                            Row(
                              children: [
                                Icon(Icons.pin_drop_outlined),
                                Text(
                                  fromlocation!,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  // key: to,
                                ),
                                Text('(arrivé)'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: Icon(
                                Icons.import_export,
                                color: Colors.black,
                                size: prefix0.height! * .07,
                              ),
                              onPressed: () {
                                // TODO Swap To And From texts
                              }))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
