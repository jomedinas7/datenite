import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //debugShowCheckedModeBanner: false,
      //title: "Setting UI",
      body: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();


  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[800],
      body:

          Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Create Profile",
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                SizedBox(width: 65,),
                Image(image: AssetImage('images/Heart.png'), height: 50, width: 50),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('images/Simu.jpg'),
                            alignment: FractionalOffset.fromOffsetAndSize(
                              const Offset(
                                1.0,
                                -10,
                              ),
                              const Size(
                                5000,
                                5000,
                              ),
                            ),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.red,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
                Image(image: AssetImage('images/Heart.png'), height: 50, width: 50),
              ]
              ),
              SizedBox(
                height: 35,
              ),
              Form(
                key: formKey,
                  child: AutofillGroup(child:
                      Column(children: [


              buildTextField("First Name", "Simu", false, firstNameController),
              buildTextField("Last Name", "Liu", false, lastNameController),
              buildTextField("Email", "ShangChickfilA@gmail.com", false, emailController),
              buildTextField("Password", "ShangChickfilA", true, confirmPasswordController),

              ]
              ),
            )
          ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      final form = formKey.currentState!;
                      if (form.validate()) {
                        // TextInput.finishAutofillContext();
                        final firstName = firstNameController.text;

                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text('Welcome $firstName!'),
                          ));
                        globalContext.read<AuthModel>().signUp(
                            email: emailController.text,
                            password: confirmPasswordController.text,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                        );
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),

    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
          validator: (value) {
            if (value != null && value.length<1) {
              return 'Enter Something';
            }
            if (value != null && isPasswordTextField && value.length<6) {
              return 'Enter Min 6 characters';
            }
            if (value != null && labelText == 'Email' && !EmailValidator.validate(controller.text)) {
              return 'Enter Valid Email';
            }
          },
        style: TextStyle(color: Colors.white),
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.white),
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
              color: Color(Colors.red[100]!.value),
            )),
      ),
    );
  }
}