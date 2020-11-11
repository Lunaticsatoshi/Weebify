import 'package:flutter/material.dart';
import 'package:weebify/Screens/signup_screen.dart';
import 'package:weebify/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  static final String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  var _expReg = new RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
      multiLine: false,
    );

  _submit(){
    if (_formKey.currentState.validate()){
     _formKey.currentState.save();
     print(_email);
     print(_password);
    //Logging In the User/Firebase
    AuthService.login(_email, _password);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 8, 24, 3),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               Text('Weebify',
               style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 70.0,
                  color: Colors.white,
              ),
              ),
               Form(
                 key: _formKey,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(45),
                         color: Colors.white
                       ),
                         child: TextFormField(
                           decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(45)),labelText: 'Email',),
                           validator: (input) => !_expReg.hasMatch(input) ? 'Please Enter a valid Email' :null,
                           onSaved: (input) => _email = input,
                         ),
                     ),
                     Container(
                       padding: EdgeInsets.symmetric(vertical: 0.0),
                       margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(45),
                         color: Colors.white
                       ),
                         child: TextFormField(
                           decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(50.0)),labelText: 'Password',),
                           validator: (input) => input.length < 6 ? 'Password must Contains atleast 6 Characters' :null,
                           onSaved: (input) => _password = input,
                           obscureText: true,
                         ),
                     ),
                     Container(
                       alignment: Alignment(0.8, 0.0),
                       padding: EdgeInsets.only( left: 20.0,),
                       child: InkWell(
                         child: Text('Forgot Password ?',
                         style: TextStyle(
                           color: Colors.redAccent,
                           fontWeight: FontWeight.bold,
                           fontFamily: 'Montserrat',
                           decoration: TextDecoration.underline,
                         ),),
                       ),
                     ),
                     SizedBox(
                       height: 20.0,
                     ),
                     Container(
                       width: 250.0,
                       child: FlatButton(
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          color: Colors.redAccent,
                          padding: EdgeInsets.all(10.0),
                          child: Text('Login',
                               style: TextStyle(
                               color: Colors.white,
                               fontSize: 20.0,
                       ),
                       ),
                     ),
                     ),
                    SizedBox(
                       height: 5.0,
                     ),
                     Container(
                       padding: EdgeInsets.symmetric(vertical: 10.0),
                       child: Column(
                         children: <Widget>[
                           Text('New To The Community ?', style: TextStyle(
                             color: Colors.white,
                             fontSize: 20.0,
                             fontFamily: 'Montserrat',
                           ),),
                         ],
                       ),
                     ),
                     Container(
                       width: 250.0,
                       child: FlatButton(
                          onPressed: () => Navigator.pushNamed(context, SignupScreen.id),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          color: Colors.redAccent,
                          padding: EdgeInsets.all(10.0),
                          child: Text('Sign Up',
                               style: TextStyle(
                               color: Colors.white,
                               fontSize: 20.0,
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
    );
  }
}
