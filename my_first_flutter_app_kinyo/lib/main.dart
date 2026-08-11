
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter App',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 44, 73, 136),
        ),
      ),

      home: const MyHomePage(
        title: 'My First Flutter App',
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          children: [

            // FIRST CARD
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: const [

                    Text(
                      '08/11/2026',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontFamily: 'serif',
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(
                      'My Flutter App',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Arial',
                      ),
                    ),

                    SizedBox(height: 25),

                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('lib/assets/gagamboy.jpg'),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Bryan E. Quiño',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontFamily: 'serif',
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      '3 - BSIT',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontFamily: 'serif',
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Hobby: Basketball',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontFamily: 'serif',
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          'Birthdate: 05/16/05',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: 'serif',
                          ),
                        ),

                        SizedBox(width: 50),

                        Text(
                          'Age: 21',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // SECOND CARD
            Card(
              elevation: 5,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: const [

                    Text(
                      'Favorite Game: Dota 2 & Valorant',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontFamily: 'serif',
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Favorite Food: High Protein Foods',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontFamily: 'serif',
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Favorite Movie: Top Gun: Maverick',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontFamily: 'serif',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ELEVATED BUTTON
            ElevatedButton(
              onPressed: () {
                print('Button pressed!');
              },
              child: const Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}

