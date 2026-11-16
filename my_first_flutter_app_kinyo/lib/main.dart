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
    studentStatus: false,
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
    studentStatus: false,
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

      // Naa diri ang initial route ug routes para sa navigation sa app
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => const StudentListScreen(),
        '/student-details': (context) => const StudentDetailsScreen(),
        '/add-student': (context) => const AddStudentScreen(),
      },
    );
  }
}

// ADD STUDENT SCREEN
class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            const Text(
              'New Student Information',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              child: const Padding(
                padding: EdgeInsets.all(20),

                child: Text(
                  'Student input form will be added here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

// STUDENT DETAILS SCREEN
class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  // Mao ni diri ang function nga nag show sa edit dialog box para sa student details
  void _showEditDialog(BuildContext context, Student student) {
    final nameController = TextEditingController(text: student.name);
    final idController = TextEditingController(text: student.studentID);
    final courseController = TextEditingController(text: student.course);
    final emailController = TextEditingController(text: student.email);
    final hobbyController = TextEditingController(text: student.hobby);
    final subjectController = TextEditingController(
      text: student.favoriteSubject,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                ),
                TextField(
                  controller: courseController,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: hobbyController,
                  decoration: const InputDecoration(labelText: 'Hobby'),
                ),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Favorite Subject',
                  ),
                ),
              ],
            ),
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ang student nga gipasa gikan sa list through route arguments
    final student = ModalRoute.of(context)!.settings.arguments as Student;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showEditDialog(context, student);
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Student',
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(student.profileImage),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    student.name ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'Student ID: ${student.studentID ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Course: ${student.course ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Status: ${student.studentStatus == null ? 'N/A' : (student.studentStatus! ? 'Active' : 'Inactive')}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Email: ${student.email ?? 'N/A'}',
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

                  const SizedBox(height: 10),

                  Text(
                    'Favorite Subject: ${student.favoriteSubject ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// STUDENT LIST SCREEN
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class LoadingScreen extends StatelessWidget {
  //nag create ko lain class para sa loading screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ), // mao ni ang loading indicator nga nag show sa screen samtang nag load ang data
      ),
    );
  }
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading =
      true; // nag set ko ug boolean variable nga isLoading para ma determine kung nag load pa ba ang data or wala
  List<bool> isFavorite = List.filled(students.length, false);
  List<bool> isEdited = List.filled(students.length, false);

  @override
  void initState() {
    // nag override ko sa initState method para ma set ang isLoading to true sa pagsugod sa app gikan rapd sa stackoverflow haha (wako kagets ngano na)
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading =
            false; // nag set ko ug delay nga 3 seconds para ma simulate ang loading sa data, human sa 3 seconds, ma set ang isLoading to false
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      isLoading // mao ni ang condition nga nag check kung nag load pa ba ang data or dili, kung nag load pa, ipakita ang loading screen, kung dili, ipakita ang main content sa app
      ? LoadingScreen()
      : Scaffold(
          backgroundColor: Colors.deepPurple.shade50,

          appBar: AppBar(
            title: const Text('Student Profiles'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-student');
            },
            tooltip: 'Add Student',
            child: const Icon(Icons.add),
          ),

          body: students.isEmpty
              ? const Center(
                  child: Text(
                    'No student profiles available.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/student-details',
                          arguments: student,
                        );
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(15),

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
                                backgroundImage: AssetImage(
                                  student.profileImage,
                                ),
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

                              if (student.studentStatus ==
                                  false) // condition para sa inactive status na student
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons
                                          .cancel, //Icon warning sa inactive status na student
                                      color: Colors
                                          .red, // para mahimong red ang icon
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Student Status: Inactive', // text sa status sa student nga inactive
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
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

                                      print(
                                        'Favorite button pressed for ${student.name}',
                                      );
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
