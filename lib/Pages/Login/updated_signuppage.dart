import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exampal/Constants/utils.dart';
import 'package:exampal/Firebase/auth_methods.dart';
import 'package:exampal/Pages/Login/updated_loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdatedSignUpPage extends StatefulWidget {
  @override
  _UpdatedSignUpPageState createState() => _UpdatedSignUpPageState();
}

class _UpdatedSignUpPageState extends State<UpdatedSignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  Uint8List? _image;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/clock.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          // Remove the bottom border
                          border: Border(
                            bottom: BorderSide.none,
                          ),
                        ),
                        child: Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: MemoryImage(_image!),
                                    backgroundColor: Colors.grey,
                                  )
                                : const CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                        'https://i.stack.imgur.com/l60Hf.png'),
                                    backgroundColor: Colors.grey,
                                  ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email Address",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _confirmpasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            _selectedDate != null
                                ? '${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'
                                : 'Select Date of Birth',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          onTap: () => _selectDate(context),
                          trailing: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (_image == null) {
                          // Show a Snackbar if no profile image is uploaded
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please upload a profile image'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (!isValidEmail(_emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a valid email'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (!passwordConfirmed()) {
                          // Show a message or perform action for mismatched passwords
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Passwords do not match'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          // Proceed with sign-up if passwords match
                          String res = await AuthMethods().signUpUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                            file: _image!,
                            dateOfBirth: _selectedDate ?? DateTime.now(),
                          );
                          print(res);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the sign-in page
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      },
                      child: FadeInUp(
                        duration: Duration(milliseconds: 2000),
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: Color.fromRGBO(143, 148, 251, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
