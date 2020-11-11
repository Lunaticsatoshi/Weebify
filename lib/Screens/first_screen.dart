import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:weebify/Animations/delayed_animation.dart';
import 'package:weebify/Screens/login_screen.dart';

class FirstScreen extends StatefulWidget {
    FirstScreen({Key key}) : super(key: key);
    static final String id = 'first_screen';
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with SingleTickerProviderStateMixin {
  
  final int delayedAmount = 500;
  double _scale;
  Animation animation;
  AnimationController animationController;
    @override
  void initState() {
    animationController = AnimationController(
      value: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  
  
  @override
  Widget build(BuildContext context) {

    _scale = 1 - animationController.value;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/flickers.jpg'),
            fit: BoxFit.fill
          ),
          color: Color(0xFFF001117).withOpacity(0.7),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                    height: 60.0,
              ),
              DelayedAnimation(
                child: Text('Welcome To',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.white,
                  fontFamily: 'Montserrat'
                ),
                ),
                delay: delayedAmount + 1000,
              ),
              DelayedAnimation(
                child: Text('Weebify',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
                ),
                delay: delayedAmount + 2000,
              ),
              SizedBox(
                    height: 30.0,
              ),
              DelayedAnimation(
                child: Text('The Destination To Showcase ',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
                ),
                delay: delayedAmount + 3000,
              ),
              DelayedAnimation(
                child: Text('Your Love for Creativity',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
                ),
                delay: delayedAmount + 4000,
              ),
              SizedBox(height: 50.0,),
              DelayedAnimation( 
                child:  Container(
                  width: 250.0,
                  child: FlatButton(
                              onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                              ),
                              color: Colors.redAccent,
                              padding: EdgeInsets.all(10.0),
                              child: Text('NEXT',
                                   style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 30.0,
                           ),
                           ),
                         ),
                ),
                       delay: delayedAmount + 5000,
              ),
            ],
          ),
        ),
      ),

    );
  }

    void _onTapDown(TapDownDetails details) {
    animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    animationController.reverse();
  }
}