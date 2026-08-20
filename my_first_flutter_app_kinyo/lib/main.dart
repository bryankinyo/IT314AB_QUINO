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
  final String? studentID;
  final String? email;
  final String? favoriteSubject;

  const Student({
    required this.profileImage,
    this.name,
    this.course,
    this.hobby,
    this.height,
    this.studentStatus,
    this.age,
    this.studentID,
    this.email,
    this.favoriteSubject,
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
    studentID: 'S001',
    email: 'bryan.quino@dtbc-cebu.edu.ph',
    favoriteSubject: 'Computer Science',
  ),

  const Student(
    profileImage: 'lib/assets/gagamboy.jpg',
    name: 'Dominic Ocarol',
    course: '3 - BSIT',
    hobby: 'Video Games',
    height: 5.11,
    studentStatus: true,
    age: 22,
    studentID: 'S002',
    email: 'dominic.ocarol@dtbc-cebu.edu.ph',
    favoriteSubject: 'Mathematics',
  ),

  const Student(
    profileImage: 'lib/assets/kapitan barbell.jpg',
    name: 'James Gulfan',
    course: '3 - BSIT',
    hobby: 'Mobile Legends',
    height: 5.9,
    studentStatus: true,
    age: 20,
    studentID: 'S003',
    email: 'james.gulfan@dtbc-cebu.edu.ph',
    favoriteSubject: 'Physics',
  ),

  const Student(
    profileImage: 'lib/assets/darna.jpg',
    name: 'Emji Syllanto',
    course: '3 - BSIT',
    hobby: 'Volleyball',
    height: 5.5,
    studentStatus: true,
    age: 23,
    studentID: 'S004',
    email: 'emji.syllanto@dtbc-cebu.edu.ph',
    favoriteSubject: 'Biology',
  ),

  const Student(
    profileImage: 'lib/assets/kidlat.jpg',
    name: 'Maverick Tajanlangit',
    course: '3 - BSIT',
    hobby: 'Dancing',
    height: 5.7,
    studentStatus: true,
    age: 22,
    studentID: 'S005',
    email: 'maverick.tajanlangit@dtbc-cebu.edu.ph',
    favoriteSubject: 'Chemistry',
  ),
];


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

// HOME PAGE
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> isFavorite = List.filled(students.length, false);
  List<bool> isEdited = List.filled(students.length, false);

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

      body: students.isEmpty
          ? const Center(
              child: Text(
                'No student profiles available.',
                style: TextStyle(fontSize: 18),
              ),
            )
            
          : ListView.builder(
          
          padding: const EdgeInsets.all(20),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
           return GestureDetector(
              onTap: () {
                print('Card tapped for ${student.name}');
              },
            child: Card(
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

                            Text(
                              'Student Card ${index + 1}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(student.profileImage),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'ID: ${student.studentID ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              student.name ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),
                            
                            Text(
                              'Email: ${student.email ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 10),
                            
                            Text(
                              'Course: ${student.course ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),


                            const SizedBox(height: 10),

                            Text(
                              'Age: ${student.age ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'Height: ${student.height?.toStringAsFixed(2) ?? 'N/A'} ft',
                              style: const TextStyle(fontSize: 16),
                            ),

                            
                            const SizedBox(height: 10),

                            Text(
                              'Hobby: ${student.hobby ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            
                            Text(
                              'Favorite Subject: ${student.favoriteSubject ?? 'N/A'}',
                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(height: 10),

                            Text(
                            'Student Status: ${student.studentStatus == null
                                ? 'Not provided'
                                : student.studentStatus!
                                    ? 'Active'
                                    : 'Inactive'}',
                            style: const TextStyle(fontSize: 16),
                          ), 
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                         IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Edit Student'),
                                  content: Text(
                                    'You are about to edit ${student.name}.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Edit'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit Student',
                        ),
                          
                          const SizedBox(width: 20),
                          
                          IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isFavorite[index] = !isFavorite[index];
                                      });

                                      print('Favorite button pressed for ${student.name}');
                                    },
                                    icon: Icon(
                                      isFavorite[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    tooltip: 'Favorite Item',
                                  ),

                          const SizedBox(width: 20),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  students.removeAt(index);
                                  isFavorite.removeAt(index);
                                  isEdited.removeAt(index);
                                });

                                print('Deleted ${student.name}');
                              },
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete Student',
                            ),

                          ],
                          ),
                          ],
                        ),
                      ),
                      
              ),

            );
          },
          
      ),
      
    );
    
  }
}