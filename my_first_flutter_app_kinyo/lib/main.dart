import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // kinahanglan ni para maka-load sa saved data before mu-start ang app
  WidgetsFlutterBinding.ensureInitialized();
  await loadStudents();
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

  // i-convert ang student ngadto sa Map para ma-save
  Map<String, dynamic> toMap() {
    return {
      'profileImage': profileImage,
      'name': name,
      'course': course,
      'hobby': hobby,
      'height': height,
      'studentStatus': studentStatus,
      'age': age,
      'studentID': studentID,
      'email': email,
      'favoriteSubject': favoriteSubject,
    };
  }

  // i-convert ang saved Map balik ngadto sa student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      profileImage: map['profileImage'],
      name: map['name'],
      course: map['course'],
      hobby: map['hobby'],
      height: (map['height'] as num?)?.toDouble(),
      studentStatus: map['studentStatus'],
      age: map['age'],
      studentID: map['studentID'],
      email: map['email'],
      favoriteSubject: map['favoriteSubject'],
    );
  }
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

// LOCAL STORAGE
// mao ni ang function nga nag save sa students list sa local storage
Future<void> saveStudents() async {
  final prefs = await SharedPreferences.getInstance();
  final savedList = students.map((s) => jsonEncode(s.toMap())).toList();
  await prefs.setStringList('students', savedList);
}

// mao ni ang function nga nag load sa saved students pagstart sa app
Future<void> loadStudents() async {
  final prefs = await SharedPreferences.getInstance();
  final savedList = prefs.getStringList('students');

  // kung wala pay nasave, gamiton ang default nga students list
  if (savedList == null) {
    return;
  }

  students.clear();
  for (final item in savedList) {
    students.add(Student.fromMap(jsonDecode(item)));
  }
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
  // key para ma validate ang form
  final _formKey = GlobalKey<FormState>();

  // controllers para sa matag input field
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController yearLevelController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Student ID: dili pwede empty ug dili pwede duplicate
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: 'Student ID',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Student ID is required';
                          }
                          for (final student in students) {
                            if (student.studentID?.toLowerCase() ==
                                value.trim().toLowerCase()) {
                              return 'Student ID already exists';
                            }
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      // Name: dili pwede empty
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full Name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      //validation sa course, dapat naay i input ang user sa course,
                      //dili pwede empty
                      TextFormField(
                        controller: courseController,
                        decoration: const InputDecoration(
                          labelText: 'Course',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Course is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // Year Level: dapat 1 to 4 ra ang value, dili pwede empty
                      TextFormField(
                        controller: yearLevelController,
                        decoration: const InputDecoration(
                          labelText: 'Year Level',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Year Level is required';
                          }
                          final year = int.tryParse(value.trim());
                          if (year == null || year < 1 || year > 4) {
                            return 'Year Level must be from 1 to 4';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // Email: kinahanglan naay @ ug dot
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email Address is required';
                          }
                          final emailPattern = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailPattern.hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Create a new Student object with the provided details
                  final newStudent = Student(
                    profileImage: 'lib/assets/lastikman.jpg',
                    studentID: idController.text.trim(),
                    name: nameController.text.trim(),
                    course:
                        '${yearLevelController.text.trim()} - ${courseController.text.trim()}',
                    email: emailController.text.trim(),
                    studentStatus: true,
                  );

                  // idugang sa students list
                  students.add(newStudent);

                  // i-save sa local storage
                  saveStudents();

                  // limpyohan ang mga fields
                  idController.clear();
                  nameController.clear();
                  courseController.clear();
                  yearLevelController.clear();
                  emailController.clear();

                  // balik sa student list
                  Navigator.pop(context);
                }
              },
              child: const Text('Enroll Student'),
            ),

            const SizedBox(height: 10),

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
class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  // ang student nga gipakita karon sa screen
  Student? currentStudent;

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
                // i-check kung ang Student ID gigamit na sa laing student
                final index = students.indexOf(student);
                for (int i = 0; i < students.length; i++) {
                  if (i != index &&
                      students[i].studentID?.toLowerCase() ==
                          idController.text.trim().toLowerCase()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Duplicate Student ID'),
                          content: const Text(
                            'Student ID already exists. Please use a different ID.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                }

                // maghimo ug updated nga student gamit ang gi-edit nga info
                final updatedStudent = Student(
                  profileImage: student.profileImage,
                  name: nameController.text.trim(),
                  studentID: idController.text.trim(),
                  course: courseController.text.trim(),
                  email: emailController.text.trim(),
                  hobby: hobbyController.text.trim(),
                  favoriteSubject: subjectController.text.trim(),
                  height: student.height,
                  studentStatus: student.studentStatus,
                  age: student.age,
                );

                // ilisan ang daan nga student sa students list
                if (index != -1) {
                  students[index] = updatedStudent;
                }

                // i-save ang changes sa local storage
                saveStudents();

                // i-update ang gipakita sa screen
                setState(() {
                  currentStudent = updatedStudent;
                });

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
    currentStudent ??= ModalRoute.of(context)!.settings.arguments as Student;
    final student = currentStudent!;

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
  List<bool> isFavorite = List.filled(students.length, false, growable: true);
  List<bool> isEdited = List.filled(students.length, false, growable: true);

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
          // mao ni ang floating action button nga nag navigate sa add student screen
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // maghulat hangtod mubalik gikan sa add student screen
              await Navigator.pushNamed(context, '/add-student');

              // i-update ang list kung naay bag-ong student
              setState(() {
                while (isFavorite.length < students.length) {
                  isFavorite.add(false);
                  isEdited.add(false);
                }
              });
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
                      onTap: () async {
                        // maghulat hangtod mubalik gikan sa student details
                        await Navigator.pushNamed(
                          context,
                          '/student-details',
                          arguments: student,
                        );

                        // i-update ang list kung naay na-edit nga student
                        setState(() {});
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

                                      // i-save ang list human sa pag-delete
                                      saveStudents();

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
