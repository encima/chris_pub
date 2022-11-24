// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> me = {};

  Future<Map<String, dynamic>> readJson() async {
    final String response = await rootBundle.loadString('vcard.json');
    final data = await json.decode(response);
    setState(() {
      me = data["contact"];
    });
    return data["contact"];
  }

  var icons = {
    "github": Icon(FontAwesomeIcons.github),
    "linkedin": Icon(FontAwesomeIcons.github),
    "lastfm": Icon(FontAwesomeIcons.github),
    "letterboxd": Icon(FontAwesomeIcons.github),
    "personal": Icon(FontAwesomeIcons.github),
    "blog": Icon(FontAwesomeIcons.blog),
    "email": Icon(Icons.email),
    "mobile": Icon(FontAwesomeIcons.mobile)
  };

  @override
  Widget build(context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: readJson(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          List<dynamic> phone = List.from(snapshot.data!["phones"]);
          List<dynamic> email = List.from(snapshot.data!["emails"]);
          Map<String, dynamic> sites = Map.from(snapshot.data!["sites"]);
          Map<String, dynamic> social = Map.from(snapshot.data!["socials"]);
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.teal,
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage("assets/images/me.jpg"),
                      ),
                      Text(
                        '${snapshot.data!["firstName"]} ${snapshot.data!["familyName"]}',
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Pacifico',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(snapshot.data!["profession"],
                          style: TextStyle(
                            fontFamily: "Source Sans Pro",
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 20,
                        width: 150,
                        child: Divider(color: Colors.teal.shade100),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: (() {
                                launchUrl(Uri.parse(social["linkedin"]!));
                              }),
                              icon: FaIcon(FontAwesomeIcons.linkedin)),
                          IconButton(
                              onPressed: (() {
                                launchUrl(Uri.parse(social["github"]!));
                              }),
                              icon: FaIcon(FontAwesomeIcons.github)),
                          IconButton(
                              onPressed: (() {
                                launchUrl(Uri.parse(social["letterboxd"]!));
                              }),
                              icon: FaIcon(FontAwesomeIcons.film)),
                          IconButton(
                              onPressed: (() {
                                launchUrl(Uri.parse(social["lastfm"]!));
                              }),
                              icon: FaIcon(FontAwesomeIcons.lastfm)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        width: 150,
                        child: Divider(color: Colors.teal.shade100),
                      ),
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 35),
                          child: ListView.builder(
                            itemCount: sites.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.sitemap,
                                  color: Colors.teal,
                                ),
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      sites[sites.keys.elementAt(index)]!));
                                },
                                title: Text(
                                  snapshot.data!["sites"]
                                      [sites.keys.elementAt(index)],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Source Sans Pro'),
                                ),
                              );
                            },
                          )),
                      SizedBox(
                        height: 20,
                        width: 150,
                        child: Divider(color: Colors.teal.shade100),
                      ),
                      // ignore: avoid_unnecessary_containers
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 35),
                          child: ListView.builder(
                            itemCount: email.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.email,
                                  color: Colors.teal,
                                ),
                                onTap: () {
                                  launchUrl(
                                      Uri.parse('mailto:${email[index]}'));
                                },
                                title: Text(
                                  email[index]!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Source Sans Pro'),
                                ),
                              );
                            },
                          )),
                      SizedBox(
                        height: 20,
                        width: 150,
                        child: Divider(color: Colors.teal.shade100),
                      ),
                      Card(
                          margin: EdgeInsets.symmetric(horizontal: 35),
                          child: ListView.builder(
                            itemCount: phone.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.phone,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  phone[index]!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Source Sans Pro'),
                                ),
                                onTap: () {
                                  launchUrl(Uri.parse('tel:${phone[index]}'));
                                },
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
