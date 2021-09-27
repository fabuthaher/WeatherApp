import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app_task/services/signUp/SignUp_bloc.dart';
import 'HomePage.dart';
import 'UserModel.dart';


class EditInfo extends StatefulWidget {
  static const routeName = '/editing';

  @override
  _EditInfoState createState() => _EditInfoState();
}
class _EditInfoState extends State<EditInfo> {
  User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final phoneEditingController = new TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
    RegisterBloc? registerBloc;
  Widget build(BuildContext context) {
    firstNameEditingController.text= loggedInUser.firstName.toString();
    lastNameEditingController.text= loggedInUser.secondName.toString();
    emailEditingController.text = loggedInUser.email.toString();
    phoneEditingController.text = loggedInUser.phone.toString();

    registerBloc = BlocProvider.of<RegisterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Information'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  BlocListener<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterInitial) {
                          Center(child: Text('Waiting'));
                        }
                        if (state is RegisterSucceed) {
                          Fluttertoast.showToast(msg: "Information Saved!");
                          Navigator.pushReplacementNamed(
                              context, HomePage.routeName);
                        }
                      },
                      child: BlocBuilder<RegisterBloc, RegisterState>
                        (
                        builder: (context, state) {
                          if (state is RegisterLoading)
                            return Center(child: CircularProgressIndicator());
                          else if (state is RegisterFailed)
                            return // just in case of an unexpected error
                              Center(child: Text(state.message));
                          else
                            return Container();
                        },
                      )
                  ),
                  // first name
                  TextFormField(
                      autofocus: false,
                      controller: firstNameEditingController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        firstNameEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "First Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  // last name
                  TextFormField(
                      autofocus: false,
                      controller: lastNameEditingController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Last Name cannot be Empty");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lastNameEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Last Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  // email
                  TextFormField(
                      autofocus: false,
                      controller: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        // reg expression for email validation
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  // phone number
                  TextFormField(
                      autofocus: false,
                      controller: phoneEditingController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Phone number");
                        }
                        // reg expression for email validation
                        if (RegExp("^[a-zA-Z+_.-]+@[a-zA-Z.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid phone number");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        phoneEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Phone number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  // password field
                  TextFormField(
                      autofocus: false,
                      controller: passwordEditingController,
                      obscureText: _obscureText,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if(value != null){
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }}
                      },
                      onSaved: (value) {
                        if(value != null)
                        passwordEditingController.text = value;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        suffixIcon:  IconButton(
                          onPressed: _toggle,
                          icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off),
                        ),
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  // confirm password field
                  TextFormField(
                      autofocus: false,
                      controller: confirmPasswordEditingController,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (confirmPasswordEditingController.text !=
                            passwordEditingController.text) {
                          return "Password don't match";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        confirmPasswordEditingController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  SizedBox(height: 25),
                  MaterialButton(
                      color: Colors.red,
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: UpdateInfo,
                      child: Text(
                        "Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void UpdateInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        registerBloc!.add(UpdateInfoPressed(email: emailEditingController.text,
            password: passwordEditingController.text, firstName: firstNameEditingController.text, lastName: lastNameEditingController.text, phone: phoneEditingController.text));
      }
      catch
      (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

}
