import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import '../provider/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _animationController;
//  Animation<Size> _heightAnimation;
  Animation<double> _opacityController;
  Animation<Offset> _slideController;

  @override
  void initState() {
    _animationController= AnimationController(vsync: this, duration: Duration(milliseconds: 300));

//    _heightAnimation= Tween<Size>(begin: Size(double.infinity, 260), end: Size(double.infinity, 320)).animate(
//      CurvedAnimation(parent: _animationController, curve: Curves.linear)
//    );

    _opacityController= Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _slideController= Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));

//    _heightAnimation.addListener(()=> setState(() {}));             // use Animated Builder instead
    super.initState();
  }

//  @override
//  void dispose() {
//    _animationController.dispose();
//    super.dispose();
//  }

  void _showErrorDialog(String message){
    showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: Text("An error occurred"),
        content: Text(message),
        elevation: 6,
        actions: <Widget>[
          FlatButton(
            child: Text("Okay"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async{
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try{
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(_authData["email"], _authData["password"]);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signUp(_authData["email"], _authData["password"]);
      }
    } on HttpException catch(error){
      var errorMessage= "Authentication failed";
      if(error.toString().contains("EMAIL_EXISTS")){
        errorMessage= "Email already exists";
      }
      else if(error.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")){
        errorMessage= "Too many attempts. Please try again later";
      }
      else if(error.toString().contains("EMAIL_NOT_FOUND")){
        errorMessage= "Provided email does not exists";
      }
      else if(error.toString().contains("INVALID_PASSWORD")){
        errorMessage= "Invalid password";
      }
      else if(error.toString().contains("USER_DISABLED")){
        errorMessage= "user account has been disabled by administrator";
      }
      else if(error.toString().contains("WEAK_PASSWORD")){
        errorMessage= "password is too weak";
      }
      else if(error.toString().contains("INVALID_EMAIL")){
        errorMessage= "Invalid email";
      }

      _showErrorDialog(errorMessage);
    }catch(error){
      const errorMessage= "Could not authenticate user. Please try again later.";
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
//        height: _heightAnimation.value.height,
        height: _authMode== AuthMode.Login ? 260 : 320,
        constraints: BoxConstraints(minHeight: _authMode== AuthMode.Login ? 260 : 320),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
//                if (_authMode == AuthMode.Signup)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(minHeight: (_authMode== AuthMode.Login ? 0 : 60), maxHeight: (_authMode== AuthMode.Login ? 0 : 120)),
                  child: FadeTransition(
                    opacity: _opacityController,
                    child: SlideTransition(
                      position: _slideController,
                      child: TextFormField(
//                          enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,)
                else
                  RaisedButton(
                    child:
                    Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






//import 'package:flutter/material.dart';
//import '../models/http_exception.dart';
//import '../provider/auth.dart';
//import 'package:provider/provider.dart';
//
//enum AuthState {Login, Signup}
//
//class AuthCard extends StatefulWidget {
//  @override
//  _AuthCardState createState() => _AuthCardState();
//}
//
//class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
//  var _authData= {
//    "email": "",
//    "password": "",
//  };
//
//  var _passwordController= TextEditingController();
//  var _authState= AuthState.Login;
//  GlobalKey<FormState> _formKey= GlobalKey<FormState>();
//  bool isLoading= false;
//
//  AnimationController _animationController;
//  Animation<Offset> _slideAnimation;
//  Animation<double> _opacityAnimation;
////  Animation<Size> _heightAnimation;
//
//  @override
//  void initState() {
//    _animationController= AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//    _slideAnimation= Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
//    _opacityAnimation= Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
//
////    _heightAnimation= Tween<Size>(begin: Size(double.infinity, 260), end: Size(double.infinity, 320)).animate(
////      CurvedAnimation(parent: _animationController, curve: Curves.linear));
//
////    _animationController.addListener(()=> setState((){}));
//    super.initState();
//  }
//
////  @override
////  void dispose() {
////    _animationController.dispose();
////    super.dispose();
////  }
//
//  switchAuthState(){
//    if(_authState== AuthState.Login){
//      setState(() {
//        _authState= AuthState.Signup;
//      });
//      _animationController.forward();
//    }
//    else{
//      setState(() {
//        _authState= AuthState.Login;
//      });
//      _animationController.reverse();
//    }
//  }
//
//  void showErrorDialog(message){
//    showDialog(
//      context: context,
//      builder: (context)=> AlertDialog(
//        elevation: 7,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(15),
//        ),
//        title: Text("An error occurred"),
//        content: Text(message),
//        contentPadding: EdgeInsets.all(15),
//        actions: <Widget>[
//          FlatButton(
//            child: Text("Okay"),
//            onPressed: (){
//              Navigator.of(context).pop();
//            },
//          ),
//        ],
//      ),
//    );
//  }
//
//  Future<void> _submit() async{
//    if(_formKey.currentState.validate()){
//      _formKey.currentState.save();
//      setState(() {
//        isLoading= true;
//      });
//      try{
//        if(_authState== AuthState.Signup){
//          await Provider.of<Auth>(context, listen: false).signUp(_authData["email"], _authData["password"]);
//        }
//        else{
//          await Provider.of<Auth>(context, listen: false).login(_authData["email"], _authData["password"]);
//        }
//      }on HttpException catch(error){
//        var errorMessage= "Authentication failed";
//        if(error.toString().contains("EMAIL_EXISTS")){
//          errorMessage= "email does not exists";
//        }
//        else if(error.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")){
//          errorMessage= "too many attempts, please try later again";
//        }
//        else if(error.toString().contains("EMAIL_NOT_FOUND")){
//          errorMessage= "email not found";
//        }
//        else if(error.toString().contains("INVALID_PASSWORD")){
//          errorMessage= "invalid password";
//        }
//        else if(error.toString().contains("USER_DISABLED")){
//          errorMessage= "your account is disabled by administrator";
//        }
//        else if(error.toString().contains("WEAK_PASSWORD")){
//          errorMessage= "weak password";
//        }
//        else if(error.toString().contains("INVALID_EMAIL")){
//          errorMessage= "invalid email";
//        }
//        showErrorDialog(errorMessage);
//      }catch(error){
//        const errorMessage= "Unable to authenticate. Please try later again";
//        showErrorDialog(errorMessage);
//      }
//
//      setState(() {
//        isLoading= false;
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final deviceSize= MediaQuery.of(context).size;
//
//    return Card(
//      margin: EdgeInsets.all(15),
//      elevation: 7,
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(15),
//      ),
////      child: SlideTransition(
////        position: _slideAnimation,
//      child: AnimatedContainer(
//        duration: Duration(milliseconds: 300),
//        curve: Curves.linear,
//        width: deviceSize.width * 0.8,
//        height: _authState== AuthState.Login ? 260 : 320,
//  //        height: _heightAnimation.value.height,
//        padding: EdgeInsets.all(10),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(15),
//          shape: BoxShape.rectangle,
//        ),
//        child: Form(
//          key: _formKey,
//          child: SingleChildScrollView(
//            child: Column(
//              children: <Widget>[
//                TextFormField(
//                  decoration: InputDecoration(
//                    border: UnderlineInputBorder(
//                      borderRadius: BorderRadius.circular(15),
//                    ),
//                    labelText: "EMAIL",
//                  ),
//                  onSaved: (value){
//                    _authData["email"]= value;
//                  },
//                  keyboardType: TextInputType.emailAddress,
//                  validator: (value){
//                    if(value.isEmpty){
//                      return "Please provide email";
//                    }
//                    else if(!value.contains("@")){
//                      return "enter valid email";
//                    }
//                    return null;
//                  },
//                ),
//                TextFormField(
//                  decoration: InputDecoration(
//                    border: UnderlineInputBorder(
//                      borderRadius: BorderRadius.circular(15),
//                    ),
//                    labelText: "PASSWORD",
//                  ),
//                  onSaved: (value){
//                    _authData["password"]= value;
//                  },
//                  obscureText: true,
//                  keyboardType: TextInputType.visiblePassword,
//                  controller: _passwordController,
//                  validator: (value){
//                    if(value.isEmpty){
//                      return "Please provide password";
//                    }
//                    else if(value.length < 6){
//                      return "password length should be at least 6 chars long";
//                    }
//                    return null;
//                  },
//                ),
//                if(_authState== AuthState.Signup)
//                  FadeTransition(
//                    opacity: _opacityAnimation,
//                    child: AnimatedContainer(
//                      duration: Duration(milliseconds: 300),
//                      curve: Curves.linear,
//                      child: SlideTransition(
//                        position: _slideAnimation,
//                        child: TextFormField(
//                          decoration: InputDecoration(
//                            border: UnderlineInputBorder(
//                              borderRadius: BorderRadius.circular(15),
//                            ),
//                            labelText: "CONFIRM PASSWORD",
//                          ),
//                          obscureText: true,
//                          keyboardType: TextInputType.visiblePassword,
//                          validator: (value){
//                            if(value.isEmpty){
//                              return "Please confirm password";
//                            }
//                            else if(value.length < 6){
//                              return "password length should be at least 6 chars long";
//                            }
//                            else if(value!= _passwordController.text){
//                              return "incorrect password";
//                            }
//                            return null;
//                          },
//                        ),
//                      ),
//                    ),
//                  ),
//
//                SizedBox(height: 15,),
//                if(isLoading)
//                  Center(
//                    child: CircularProgressIndicator(
//                      backgroundColor: Theme.of(context).primaryColor,
//                    ),
//                  )
//                else
//                  RaisedButton(
//                    child: Text(_authState== AuthState.Login ? "LOGIN" : "SIGN UP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5,),),
//                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(15),
//                    ),
//                    color: Theme.of(context).primaryColor,
//                    elevation: 5,
//                    onPressed: (){
//                      _submit();
//                    },
//                  ),
//
//                SizedBox(height: 10,),
//                FlatButton(
//                  child: Text("${_authState== AuthState.Signup ? "LOGIN" : "SIGN UP"} INSTEAD",
//                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5,),),
//                  padding: EdgeInsets.all(10),
//                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                  textColor: Theme.of(context).primaryColor,
//                  onPressed: (){
//                    switchAuthState();
//                  },
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}

