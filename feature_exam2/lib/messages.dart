import 'package:flutter/material.dart';
// import 'lib/main.dart';

class ValorantMessages extends StatelessWidget {
  final String user6 = 'noobsaur';
  final String away = 'Away';
  final String device = 'Riot Mobile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              Text(
                'Messages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            color: Colors.black,
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                left: 35,
                right: 0,
                top: 10,
                bottom: 180,
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),

                      Icon(Icons.dark_mode, size: 15, color: Colors.yellow),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$user6',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sans-serif',
                        ),
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.mobile_friendly,
                            size: 15,
                            color: Colors.white60,
                          ),

                          Text(
                            '$away - $device',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
