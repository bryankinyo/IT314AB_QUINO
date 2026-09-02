import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 60, 60, 60),
      ),
      home: _MyHomePageState(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

class _MyHomePageState extends StatelessWidget {
  final String friends = 'Friends';
  final String messages = 'Messages';
  final String requests = 'Requests';
  final String search = 'Search';
  final String online = 'Online';
  final String playing = 'Playing';
  final String away = 'Away';
  final String game = 'VALORANT';
  final int pcOnlineCount = 3;
  final int onlineCount = 4;
  final String user1 = 'MissYouLikeKrazy';
  final String user2 = 'bread';
  final String user3 = 'The14th';
  final String user4 = 'Carlvendish';
  final String user5 = 'D1yah';
  final String device = 'Riot Mobile';

  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Social',
          style: TextStyle(
            fontFamily: 'arial',
            fontWeight: FontWeight.bold,
            fontSize: 45,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              color: Colors.black,
              child: Padding(
                padding: EdgeInsetsGeometry.all(16.0),
                child: Row(
                  children: [
                    Text(
                      '$friends',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sans-serif',
                      ),
                    ),

                    SizedBox(width: 20),

                    Text(
                      '$messages',
                      style: TextStyle(fontSize: 18, fontFamily: 'sans-serif', color: Colors.white54),
                    ),

                    SizedBox(width: 20),

                    Text(
                      '$requests',
                      style: TextStyle(fontSize: 18, fontFamily: 'sans-serif', color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: EdgeInsets.only(top: 1, bottom: 0, left: 0, right: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              color: Colors.black,
              child: Padding(
                padding: EdgeInsetsGeometry.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),

                  child: Padding(
                    padding: EdgeInsetsGeometry.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.search, size: 20, color: Colors.white54),

                        SizedBox(width: 20),

                        Text(
                          '$search',
                          style: TextStyle(fontSize: 20, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              color: Colors.black,
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 25,
                  right: 0,
                  top: 0,
                  bottom: 0,
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 30),

                    SizedBox(width: 10),

                    Text(
                      '$game',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        fontFamily: 'sans-serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 10),

                    Text(
                      '$pcOnlineCount',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white30,
                        fontFamily: 'sans-serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
                  bottom: 0,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 20, 20, 20),
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.redAccent,
                          ),
                        ),

                        Icon(Icons.circle, size: 15, color: Colors.green),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$user1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sans-serif',
                          ),
                        ),

                        Row(children: [
                        Icon(Icons.computer, size: 15, color: Colors.white60),
                        Text(
                          '$online - $game',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          )
                          )
                        ],)
                      ],
                    ),
                  ],
                ),
              ),
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
                  bottom: 0,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 20, 20, 20),
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.redAccent,
                          ),
                        ),

                        Icon(Icons.play_circle, size: 15, color: Colors.lightBlueAccent),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$user2',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sans-serif',
                          ),
                        ),

                        Row(children: [
                        Icon(Icons.computer, size: 15, color: Colors.white60),
                        Text(
                          '$playing - $game',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          )
                          )
                        ],)
                      ],
                    ),
                  ],
                ),
              ),
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
                  bottom: 0,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 20, 20, 20),
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.redAccent,
                          ),
                        ),

                        Icon(Icons.play_circle, size: 15, color: Colors.lightBlueAccent),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$user3',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sans-serif',
                          ),
                        ),

                        Row(children: [
                        Icon(Icons.computer, size: 15, color: Colors.white60),
                        Text(
                          '$playing - $game',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          )
                          )
                        ],)
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              color: Colors.black,
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 20,
                  right: 0,
                  top: 10,
                  bottom: 0,
                ),
                child: Row(children: [
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
                  ),

                  SizedBox(width: 10),

                  Text(
                    '$onlineCount',
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
                  )
                ],)
              ),
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
                  bottom: 0,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 20, 20, 20),
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
                          '$user4',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sans-serif',
                          ),
                        ),

                        Row(children: [
                        Icon(Icons.mobile_friendly, size: 15, color: Colors.white60),
                        Text(
                          '$away - $device',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          )
                          )
                        ],)
                      ],
                    ),
                  ],
                ),
              ),
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
                  bottom: 190,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 20, 20, 20),
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
                          '$user5',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sans-serif',
                          ),
                        ),

                        Row(children: [
                        Icon(Icons.mobile_friendly, size: 15, color: Colors.white60),
                        Text(
                          '$away - $device',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          )
                          )
                        ],)
                      ],
                    ),
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
