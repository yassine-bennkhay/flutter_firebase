import '../screens/guest_home_screen.dart';
import '../widgets/user_image_picker.dart';
import 'package:chicken/screens/guest_home_screen.dart';
import 'package:chicken/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading, this.userImageLink);
  bool isLoading;
  final String userImageLink;
  final void Function(
    String email,
    String password,
    String userName,
    String number,
    XFile image,
    String userImage,
    bool isLogin,
    BuildContext ctx,
  ) submitFn; //accept the function _submitAuthForm
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isPasswordVisible = true;
  final _formKey = GlobalKey<FormState>();
  TextStyle myTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontFamily: 'RobotoRegular',
  );
  var _userEmail = '';
  var _userPassword = '';
  var _userName = '';
  var _number = '';
  XFile _userPickedImage;
  String userImage;
  var _isLogin = true;

  void _pickedImage(XFile image) {
    _userPickedImage = image;
  }

  void _trySubmit() {
    print(_userPassword);
    print(_userEmail);
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    /*  if (_userPickedImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text('No Image Picked Yet, Please add one'),
        ),
      );
      return;
    }*/
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _number.trim(),
        _userPickedImage,
        userImage,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'RobotoRegular',
                    ),
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 80, color: Colors.white),
                        //borderSide: const BorderSide(),
                      ),
                      labelText: 'Email Address',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      style: myTextStyle,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      style: myTextStyle,
                      key: ValueKey('number'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 10) {
                          return 'number should be 10 characters';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Phone number',
                      ),
                      onSaved: (value) {
                        _number = value;
                      },
                    ),
                  TextFormField(
                    style: myTextStyle,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password can be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        )),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    obscureText: isPasswordVisible,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 45,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(
                          _isLogin ? 'Login' : 'SignUp',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoMedium',
                          ),
                        ),
                        /* style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          )))*/
                      ),
                    ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(
                      _isLogin
                          ? 'Create a new account!'
                          : 'I already have an account.',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'RobotoMedium'),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 45,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GuestHomeScreen(userImage),
                            ));
                      },
                      child: Text(
                        'Guest',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'RobotoMedium',
                        ),
                      ),
                    ),
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
