import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'path.dart';

void main() {
  runApp(AppointmentPage());
}

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  int step = 1;
  String _userName = '';
  String _userAge = '';
  String _userGender = '';
  String _userHeight = '';
  List<String> userSymptoms = [];
  List<dynamic> symptomSpecialistData = [];

  @override
  void initState() {
    super.initState();
    _botGreeting();
    _loadSymptomSpecialistData(); // Load symptom-specialist mapping data
  }

  Future<void> _loadSymptomSpecialistData() async {
    try {
      final String data =
          await rootBundle.loadString('assets/symptom_specialist_mapping.json');
      setState(() {
        symptomSpecialistData = json.decode(data)['symptomSpecialistMapping'];
      });
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  Future<void> _botGreeting() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "Hello! How are you doing today?",
          isUser: false,
        ),
      );
    });
    _botProvideOptions();
  }

  void _botProvideOptions() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "1. Doing Great\n2. Not feeling so good",
          isUser: false,
        ),
      );
    });
  }

  void _handleUserResponse(String text) async {
    _textController.clear();
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
    });

    text = _capitalizeFirstLetterOfEachWord(
        text); // Convert the first letter of each word to uppercase

    if (step == 1) {
      bool containsNegativeKeyword = false;
      final List<String> words = text.split(' ');

      // Check each word for negative keywords
      for (String word in words) {
        if (word.contains('no') ||
            word.contains("i don't") ||
            word.contains('not') ||
            word.contains('problem') ||
            word.contains('Problem') ||
            word.contains('Not') ||
            word.contains('No') ||
            word.contains('I don' 't') ||
            word.contains('nope')) {
          containsNegativeKeyword = true;
          break; // Stop checking if a negative keyword is found
        }
      }

      if (containsNegativeKeyword) {
        // Display a reassuring message
        _messages.insert(
          0,
          ChatMessage(
            text: "No worries, I am here to help. Let's proceed with...",
            isUser: false,
          ),
        );

        _botAskName(); // Proceed with the second option
        step = 2;
      } else {
        _botProvideOptions(); // Proceed with the first option
      }
    } else if (step == 2) {
      _handleUserName(text);
    } else if (step == 3) {
      _handleUserAge(text);
    } else if (step == 4) {
      _handleUserGender(text);
    } else if (step == 5) {
      _handleUserHeight(text);
    } else if (step == 6) {
      _handleUserWeight(text);
    } else if (step == 7) {
      _handleUserSymptoms(text);
    } else if (step == 8) {
      _botAskAppointment();
    } else if (step == 9) {
      _handleAppointmentResponse(true);
    } else if (step == 10) {
      _handleMapThing();
    } else if (step == 11) {
      _handleMapResponse(true);
    }
  }

  String _capitalizeFirstLetterOfEachWord(String input) {
    List<String> words = input.split(' ');
    List<String> capitalizedWords = [];
    for (String word in words) {
      if (word.isNotEmpty) {
        capitalizedWords.add('${word[0].toUpperCase()}${word.substring(1)}');
      }
    }
    return capitalizedWords.join(' ');
  }

  void _botAskName() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "Please enter your name.",
          isUser: false,
        ),
      );
    });
  }

  void _handleUserName(String name) {
    setState(() {
      _userName = name;
      _messages.insert(
        0,
        ChatMessage(
          text: "Your name is: $name",
          isUser: false,
        ),
      );
    });
    _botAskAge();
    step = 3;
  }

  void _botAskAge() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "Please enter your age.",
          isUser: false,
        ),
      );
    });
  }

  void _handleUserAge(String age) {
    setState(() {
      _userAge = age;
      _messages.insert(
        0,
        ChatMessage(
          text: "Your age is: $age",
          isUser: false,
        ),
      );
    });
    _botAskGender();
    step = 4;
  }

  void _botAskGender() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "Please enter your gender.",
          isUser: false,
        ),
      );
    });
  }

  void _handleUserGender(String gender) {
    setState(() {
      _userGender = gender;
      _messages.insert(
        0,
        ChatMessage(
          text: "Your gender is: $gender",
          isUser: false,
        ),
      );
    });
    _botAskHeight();
    step = 5;
  }

  void _botAskHeight() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "Please enter your height (in cms).",
          isUser: false,
        ),
      );
    });
  }

  void _handleUserHeight(String height) {
    setState(() {
      _userHeight = height;
      _messages.insert(
        0,
        ChatMessage(
          text: "Your height is: $height cm",
          isUser: false,
        ),
      );
    });
    _botAskWeight();
    step = 6;
  }

  void _botAskWeight() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "Please enter your weight (in kgs).",
          isUser: false,
        ),
      );
    });
  }

  void _handleUserWeight(String weight) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = {
      'Name': _userName,
      'Age': _userAge,
      'Gender': _userGender,
      'Height': _userHeight,
      'Weight': weight,
    };

    await prefs.setString('userDetails', json.encode(userJson));

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text:
              "Your weight is: $weight kg. Thank you! Your information has been saved.",
          isUser: false,
        ),
      );
    });

    // Continue the conversation or perform other actions here
    _botAskSymptoms();
    step = 7;
  }

  void _botAskSymptoms() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text:
              "Great! Now can you tell me your symptoms? (Please separate multiple symptoms with commas)",
          isUser: false,
        ),
      );
    });
  }

  void _handleUserSymptoms(String symptomsText) {
    final List<String> symptoms = symptomsText.split(',');
    userSymptoms = symptoms.map((symptom) => symptom.trim()).toList();

    if (userSymptoms.isEmpty) {
      _botAskSymptoms(); // Ask again if no symptoms provided
    } else {
      final List<String> specialists = matchSymptomsToSpecialists(userSymptoms);
      _botRecommendSpecialists(specialists);
    }
  }

  List<String> matchSymptomsToSpecialists(List<String> symptoms) {
    List<String> specialists = [];

    for (String symptom in symptoms) {
      for (var mapping in symptomSpecialistData) {
        if (mapping['symptom'].toLowerCase() == symptom.toLowerCase()) {
          // Cast the elements in mapping['specialists'] to strings
          List<dynamic> specialistList = mapping['specialists'];
          specialists.addAll(
              specialistList.map((specialist) => specialist.toString()));
        }
      }
    }

    return specialists.toSet().toList(); // Remove duplicates
  }

  void _botRecommendSpecialists(List<String> specialists) {
    setState(() {
      if (specialists.isNotEmpty) {
        _messages.insert(
          0,
          ChatMessage(
            text:
                "Based on your symptoms, you may consider consulting the following specialist(s):\n${specialists.join(', ')}",
            isUser: false,
          ),
        );
      } else {
        _messages.insert(
          0,
          ChatMessage(
            text:
                "I couldn't find any specialists based on your symptoms. Please provide more details or consult a general physician.",
            isUser: false,
          ),
        );
      }
    });
    _botAskAppointment();
    step = 8;
  }

  void _botAskAppointment() {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "No",
          isUser: false,
          onTap: () {
            // Handle user response when they tap "No"
            _handleAppointmentResponse(false);
            step = 9; // Call your method here
          },
        ),
      );
    });

    // Add buttons for user response
    _messages.insert(
      1,
      ChatMessage(
        text: "Yes",
        isUser: false,
        onTap: () {
          // Handle user response when they tap "Yes"
          print("yes");
          _handleAppointmentResponse(true);
          step = 9; // Call your method here
        },
      ),
    );

    _messages.insert(
      2,
      ChatMessage(
        text: "Do you want me to schedule an appointment for you?",
        isUser: false,
      ),
    );
  }

  void _handleAppointmentResponse(bool isAppointmentRequested) {
    if (isAppointmentRequested) {
      step = 10;

      // Create a ChatMessage to display the list of doctors
      ChatMessage doctorsMessage = ChatMessage(
        text: "Here is a list of doctors:",
        isUser: false,
      );

      // Add the doctors' information to the chat
      _messages.insert(0, doctorsMessage);

      // Add each doctor's information to the chat as separate messages
      for (Map<String, String> doctor in dummyDoctorList) {
        String doctorInfo = "Doctor: ${doctor['name']}\n"
            "Specialty: ${doctor['specialty']}\n"
            "Location: ${doctor['location']}\n"
            "Phone: ${doctor['phone']}";

        ChatMessage doctorMessage = ChatMessage(
          text: doctorInfo,
          isUser: false,
        );

        _messages.insert(0, doctorMessage);
      }

      // Proceed with the map step
      _handleMapThing();
    } else {
      // Handle the case where the user does not want to schedule an appointment
      _messages.insert(
        0,
        ChatMessage(
          text: "You chose not to schedule an appointment.",
          isUser: false,
        ),
      );

      // Add other responses or actions as needed
    }
  }

  void _handleMapThing() {
    {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: "No",
            isUser: false,
            onTap: () {
              // Handle user response when they tap "No"
              _handleMapResponse(false);
              step = 11; // Call your method here
            },
          ),
        );
      });

      // Add buttons for user response
      _messages.insert(
        1,
        ChatMessage(
          text: "Yes",
          isUser: false,
          onTap: () {
            // Handle user response when they tap "Yes"
            print("yes");
            _handleMapResponse(true);
            step = 11; // Call your method here
          },
        ),
      );

      _messages.insert(
        2,
        ChatMessage(
          text:
              "Do you want me to trace the map for you in correspondence to the hospital?",
          isUser: false,
        ),
      );
    }
  }

  void _handleMapResponse(bool isMapRequested) {
    if (isMapRequested) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapApp()), // Navigate to MapApp
      );
    } else {
      // User does not want to schedule an appointment
      // Add your logic here for handling this case
      _messages.insert(
        0,
        ChatMessage(
          text: "You chose not to get a map.",
          isUser: false,
        ),
      );
      // Add other responses or actions as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthcare Chatbot'),
      ),
      backgroundColor: Colors.blueGrey, // Set the background color here
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleUserResponse,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleUserResponse(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final Function? onTap;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorLocation;
  final String doctorPhone;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.onTap,
    this.doctorName = '',
    this.doctorSpecialty = '',
    this.doctorLocation = '',
    this.doctorPhone = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blueAccent : Colors.grey,
                  borderRadius: isUser
                      ? BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (doctorName.isNotEmpty) ...[
                      SizedBox(height: 5.0),
                      DoctorCard(
                        name: doctorName,
                        specialty: doctorSpecialty,
                        location: doctorLocation,
                        phone: doctorPhone,
                      ),
                    ],
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

List<Map<String, String>> dummyDoctorList = [
  {
    "name": "Dr. John Smith",
    "specialty": "Internal Medicine",
    "location": "City Hospital",
    "phone": "123-456-7890"
  },
  {
    "name": "Dr. Emily Johnson",
    "specialty": "Internal Medicine",
    "location": "County Medical Center",
    "phone": "987-654-3210"
  },
  {
    "name": "Dr. Sarah Davis",
    "specialty": "Neurologist",
    "location": "City Clinic",
    "phone": "555-555-5555"
  },
  {
    "name": "Dr. Michael Brown",
    "specialty": "Neurologist",
    "location": "County Neurology Center",
    "phone": "777-888-9999"
  },
  {
    "name": "Dr. Laura Wilson",
    "specialty": "Gastroenterologist",
    "location": "Gut Health Center",
    "phone": "888-777-9999"
  }
];

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String location;
  final String phone;

  DoctorCard({
    required this.name,
    required this.specialty,
    required this.location,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doctor: $name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Specialty: $specialty',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green, // Customize the icon color
            ),
          ),
          Text(
            'Location: $location',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red, // Customize the icon color
            ),
          ),
          Text(
            'Phone: $phone',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue, // Customize the icon color
            ),
          ),
        ],
      ),
    );
  }
}
