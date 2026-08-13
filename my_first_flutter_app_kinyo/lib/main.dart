import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Student {
  final String? name;
  final String? course;
  final String? hobby;
  final String profileImage;
  final double? height;
  final bool? studentStatus;
  final int? age;

  const Student({
    required this.profileImage,
    this.name,
    this.course,
    this.hobby,
    this.height,
    this.studentStatus,
    this.age,
  });
}

final List<Student> students = [
  const Student(
    profileImage: 'lib/assets/lastikman.jpg',
    name: 'Bryan E. Quiño',
    course: '3 - BSIT',
    hobby: 'Basketball',
    height: 5.7,
    studentStatus: true,
    age: 21,
  ),

  const Student(
    profileImage: 'lib/assets/gagamboy.jpg',
    name: 'Dominic Ocarol',
    course: '3 - BSIT',
    height: 5.11,
    studentStatus: true,
    age: 22,
  ),

  const Student(
    profileImage: 'lib/assets/kapitan barbell.jpg',
    name: 'James Gulfan',
    hobby: 'Mobile Legends',
    height: 5.9,
    studentStatus: true,
    age: 20,
  ),

  const Student(
    profileImage: 'lib/assets/darna.jpg',
    name: 'Emji Syllanto',
    course: '3 - BSIT',
    hobby: 'Volleyball',
    height: 5.5,
    studentStatus: true,
    age: 23,
  ),

  const Student(
    profileImage: 'lib/assets/kidlat.jpg',
    name: 'Maverick Tajanlangit',
    course: '3 - BSME',
    height: 5.7,
    studentStatus: true,
    age: 22,
  ),
];

// =========================
// MY APP
// =========================

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

      home: const MyHomePage(),
    );
  }
}

// =========================
// HOME PAGE
// =========================

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Student Profiles'),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),

      body: Scrollbar(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          const Text(
                            'Student Card 1',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Times New Roman',
                            ),
                          ),

                          const SizedBox(height: 25),

                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(students[0].profileImage),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            students[0].name ?? 'Not provided',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Course: ${students[0].course ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Hobby: ${students[0].hobby ?? 'Not provided'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Student Status: '
                            '${students[0].studentStatus == null
                                ? 'Not provided'
                                : students[0].studentStatus!
                                    ? 'Active'
                                    : 'Inactive'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                'Age: ${students[0].age ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),

                              const SizedBox(width: 30),

                              Text(
                                'Height: ${students[0].height ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Second Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          const Text(
                            'Student Card 2',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Times New Roman',
                            ),
                          ),

                          const SizedBox(height: 25),

                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(students[1].profileImage),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            students[1].name ?? 'Not provided',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Course: ${students[1].course ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Hobby: ${students[1].hobby ?? 'Not provided'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Student Status: '
                            '${students[1].studentStatus == null
                                ? 'Not provided'
                                : students[1].studentStatus!
                                    ? 'Active'
                                    : 'Inactive'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                'Age: ${students[1].age ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),

                              const SizedBox(width: 30),

                              Text(
                                'Height: ${students[1].height ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // THIRD CARD
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          const Text(
                            'Student Card 3',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Times New Roman',
                            ),
                          ),

                          const SizedBox(height: 25),

                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(students[2].profileImage),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            students[2].name ?? 'Not provided',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Course: ${students[2].course ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Hobby: ${students[2].hobby ?? 'Not provided'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Student Status: '
                            '${students[2].studentStatus == null
                                ? 'Not provided'
                                : students[2].studentStatus!
                                    ? 'Active'
                                    : 'Inactive'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                'Age: ${students[2].age ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),

                              const SizedBox(width: 30),

                              Text(
                                'Height: ${students[2].height ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FOURTH CARD
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          const Text(
                            'Student Card 4',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Times New Roman',
                            ),
                          ),

                          const SizedBox(height: 25),

                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(students[3].profileImage),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            students[3].name ?? 'Not provided',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Course: ${students[3].course ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Hobby: ${students[3].hobby ?? 'Not provided'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Student Status: '
                            '${students[3].studentStatus == null
                                ? 'Not provided'
                                : students[3].studentStatus!
                                    ? 'Active'
                                    : 'Inactive'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                'Age: ${students[3].age ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),

                              const SizedBox(width: 30),

                              Text(
                                'Height: ${students[3].height ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FIFTH CARD
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          const Text(
                            'Student Card 5',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Times New Roman',
                            ),
                          ),

                          const SizedBox(height: 25),

                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(students[4].profileImage),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            students[4].name ?? 'Not provided',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Course: ${students[4].course ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Hobby: ${students[4].hobby ?? 'Not provided'}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Student Status: '
                            '${students[4].studentStatus == null
                                ? 'Not provided'
                                : students[4].studentStatus!
                                    ? 'Active'
                                    : 'Inactive'}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: 'sans-serif',
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                'Age: ${students[4].age ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),

                              const SizedBox(width: 30),

                              Text(
                                'Height: ${students[4].height ?? 'Not provided'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontFamily: 'sans-serif',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}