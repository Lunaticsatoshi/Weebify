import 'package:flutter/material.dart';
import 'package:weebify/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key key}) : super(key: key);
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

    final _formKey = GlobalKey<FormState>();
  String _email, _password, _name;
  var _expReg = new RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
      multiLine: false,
    );

  _submit(){
    if (_formKey.currentState.validate()){
     _formKey.currentState.save();
    //Logging In the User/Firebase
    AuthService.signUPUser(context, _name, _email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 8, 24, 3),
      body: SingleChildScrollView(
          child: Container(
             height: MediaQuery.of(context).size.height,
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               Text('Weebify',
               style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 50.0,
                  color: Colors.white,
              ),
              ),
               Form(
                 key: _formKey,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                       decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(45),
                       color: Colors.white
                       ),
                         child: TextFormField(
                           decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(45)),labelText: 'UserName'),
                           validator: (input) => input.trim().isEmpty ? 'Please Enter a valid Name' :null,
                           onSaved: (input) => _name = input,
                         ),
                     ),
                     Container(
                         margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(45),
                         color: Colors.white
                       ),
                         child: TextFormField(
                           decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(45)),labelText: 'Email'),
                           validator: (input) => !_expReg.hasMatch(input) ? 'Please Enter a valid Email' :null,
                           onSaved: (input) => _email = input,
                         ),
                     ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                        decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(45),
                         color: Colors.white
                       ),
                         child: TextFormField(
                           decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(45)),labelText: 'Password'),
                           validator: (input) => input.length < 6 ? 'Password must Contains atleast 6 Characters' :null,
                           onSaved: (input) => _password = input,
                           obscureText: true,
                         ),
                      ),
                     SizedBox(
                       height: 35.0,
                     ),
                     Container(
                       margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                       decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(45),
                      color: Colors.white
                       ),
                       width: 250.0,
                       child: FlatButton(
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          color: Colors.redAccent,
                          padding: EdgeInsets.all(15.0),
                          child: Text('Sign Up',
                               style: TextStyle(
                               color: Colors.white,
                               fontSize: 20.0,
                       ),
                       ),
                     ),
                     ),
                    SizedBox(
                       height: 35.0,
                     ),
                   ],
                 ),
               ),
            ],
          ),
        ),
    )
    ) ;
  }
}