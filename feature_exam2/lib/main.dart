import 'package:flutter/material.dart';
import 'messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 60, 60, 60),
      ),
      home: MyHomePageState(),
    );
  }
}

class MyHomePageState extends StatefulWidget {
  @override
  State<MyHomePageState> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageState> {
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

  final String Logo = 'assets/Screenshot 2026-09-17 133839.png';

  @override
  Widget build(BuildContext context) {
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

      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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

                   
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ValorantMessages(),
                            ),
                          );
                        },
                        child: Text(
                          '$messages',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'sans-serif',
                            color: Colors.white54,
                          ),
                        ),
                      ),

                      SizedBox(width: 20),

                      Text(
                        '$requests',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'sans-serif',
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                margin: EdgeInsets.only(
                  top: 1,
                  bottom: 0,
                  left: 0,
                  right: 0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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

                          Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.white54,
                          ),

                          SizedBox(width: 20),

                          Text(
                            '$search',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

         
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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

                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(Logo),
                        backgroundColor: Colors.black,
                      ),

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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
                            backgroundColor: Color.fromARGB(
                              255,
                              20,
                              20,
                              20,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.redAccent,
                            ),
                          ),

                          Icon(
                            Icons.circle,
                            size: 15,
                            color: Colors.green,
                          ),
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

                          Row(
                            children: [

                              Icon(
                                Icons.computer,
                                size: 15,
                                color: Colors.white60,
                              ),

                              Text(
                                '$online - $game',
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

       
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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
                            backgroundColor: Color.fromARGB(
                              255,
                              20,
                              20,
                              20,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.redAccent,
                            ),
                          ),

                          Icon(
                            Icons.play_circle,
                            size: 15,
                            color: Colors.lightBlueAccent,
                          ),
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

                          Row(
                            children: [

                              Icon(
                                Icons.computer,
                                size: 15,
                                color: Colors.white60,
                              ),

                              Text(
                                '$playing - $game',
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

     
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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
                            backgroundColor: Color.fromARGB(
                              255,
                              20,
                              20,
                              20,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.redAccent,
                            ),
                          ),

                          Icon(
                            Icons.play_circle,
                            size: 15,
                            color: Colors.lightBlueAccent,
                          ),
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

                          Row(
                            children: [

                              Icon(
                                Icons.computer,
                                size: 15,
                                color: Colors.white60,
                              ),

                              Text(
                                '$playing - $game',
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

        
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: 20,
                    right: 0,
                    top: 10,
                    bottom: 0,
                  ),
                  child: Row(
                    children: [

                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(width: 10),

                      Text(
                        '$onlineCount',
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

        
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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
                            backgroundColor: Color.fromARGB(
                              255,
                              20,
                              20,
                              20,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),

                          Icon(
                            Icons.dark_mode,
                            size: 15,
                            color: Colors.yellow,
                          ),
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

            
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
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
                            backgroundColor: Color.fromARGB(
                              255,
                              0,
                              0,
                              0,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),

                          Icon(
                            Icons.dark_mode,
                            size: 15,
                            color: Colors.yellow,
                          ),
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
          );
        },
      ),
    );
  }
}