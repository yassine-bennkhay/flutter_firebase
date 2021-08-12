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
  final _formKey = GlobalKey<FormState>();
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
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('number'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 10) {
                          return 'number should be 10 characters';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                      ),
                      onSaved: (value) {
                        _number = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password can be at least 7 characters long.';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(
                          _isLogin ? 'Login' : 'SignUp',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )))),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(_isLogin
                        ? 'Create a new account'
                        : 'I already have an account.'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => guestHomeScreen(userImage),
                          ));
                    },
                    child: Text('Guest'),
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