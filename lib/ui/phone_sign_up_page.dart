import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:radency_internship_project_2/blocs/sign_up/sign_up_phone/sign_up_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/ui/shared_components/elevated_buttons/colored_elevated_button.dart';
import 'package:radency_internship_project_2/utils/strings.dart';

class PhoneSignUpPage extends StatelessWidget {
  const PhoneSignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.signUpPageTitle)),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: BlocProvider<PhoneSignUpBloc>(
          create: (_) => PhoneSignUpBloc(context.read<FirebaseAuthenticationService>()),
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;
  String _phoneNumber;
  String _username;
  String _oneTimePassword;

  bool otpHasError = false;

  TextEditingController codeController;

  StreamController<ErrorAnimationType> errorController;

  static const double _padding = 0.0;

  @override
  void initState() {
    super.initState();
    if (errorController == null || !errorController.hasListener) {
      errorController = StreamController<ErrorAnimationType>();
    }
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneSignUpBloc, PhoneSignUpState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
        }
      },
      builder: (context, state) {
        switch (state.signUpPageMode) {
          case PhoneSignUpPageMode.Credentials:
            return _signUpDetails();
            break;
          case PhoneSignUpPageMode.OTP:
            return _otpInput();
            break;
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _signUpDetails() {
    return centeredScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 8,
        ),
        Text(
          S.current.signUpCreateAccountHeader,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          S.current.signUpOTPNotice,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        _detailsForm(),
      ],
    ));
  }

  Widget _detailsForm() {
    return BlocBuilder<PhoneSignUpBloc, PhoneSignUpState>(builder: (context, state) {
      return Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_phoneNumberField(), _emailField(), _usernameField()],
              )),
          ColoredElevatedButton(
            onPressed: state.areDetailsProcessing
                ? null
                : () {
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate()) {
                      if (!errorController.isClosed) {
                        errorController.close();
                      }
                      errorController = StreamController<ErrorAnimationType>();
                      context.read<PhoneSignUpBloc>().add(
                          SignUpCredentialsSubmitted(phoneNumber: _phoneNumber, email: _email, username: _username));
                    }
                  },
            child: state.areDetailsProcessing
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onSecondary),
                    ),
                  )
                : Text(S.current.signUpApplyCredentialsButton),
          )
        ],
      );
    });
  }

  Widget _phoneNumberField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _padding),
      child: TextFormField(
        initialValue: _phoneNumber?.replaceAll('+', '') ?? '',
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefix: Text('+'),
            helperText: '',
            labelText: S.current.signUpPhoneNumberLabelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) {
            return S.current.signUpPhoneNumberValidatorEmpty;
          }

          if (!RegExp(phoneNumberRegExp).hasMatch(val)) {
            return S.current.signUpPhoneNumberValidatorIncorrect;
          }

          return null;
        },
        onSaved: (value) => _phoneNumber = '+$value',
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _padding),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        initialValue: _email ?? '',
        decoration: InputDecoration(
            helperText: '',
            labelText: S.current.signUpEmailLabelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) {
            return S.current.signUpEmailValidatorEmpty;
          }

          if (!RegExp(emailRegExp).hasMatch(val)) {
            return S.current.signUpEmailValidatorIncorrect;
          }

          return null;
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _padding),
      child: TextFormField(
        initialValue: _username ?? '',
        decoration: InputDecoration(
            helperText: '',
            labelText: S.current.signUpUsernameLabelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) {
            return S.current.signUpUsernameValidatorEmpty;
          }

          return null;
        },
        onSaved: (value) => _username = value,
      ),
    );
  }

  Widget _otpInput() {
    return centeredScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20),
        Text(
          S.current.signUpOTPSentNotice,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 10),
        Text(
          _phoneNumber,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 8),
        TextButton(
          child: Text(
            S.current.signUpWrongNumberButton,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          onPressed: () {
            setState(() {
              context.read<PhoneSignUpBloc>().add(SignUpWrongNumberPressed());
              _oneTimePassword = '';
            });
          },
        ),
        SizedBox(height: 20),
        _pinCodeField(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            otpHasError ? S.current.signUpOTPValidatorIncorrect : "",
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
        verifyOtpSection(),
      ],
    ));
  }

  Widget _pinCodeField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: new PinCodeTextField(
        appContext: context,
        autoFocus: true,
        length: 6,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 30,
          fieldWidth: 30,
          selectedColor: Theme.of(context).accentColor,
          selectedFillColor: Colors.blueGrey,
          inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
          inactiveColor: Theme.of(context).disabledColor,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: codeController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onCompleted: (v) {},
        onChanged: (value) {
          print(value);
          setState(() {
            _oneTimePassword = value;
          });
        },
        beforeTextPaste: (text) {
          return false;
        },
      ),
    );
  }

  Widget verifyOtpSection() {
    return BlocBuilder<PhoneSignUpBloc, PhoneSignUpState>(builder: (context, state) {
      return Container(
        child: TextButton(
          onPressed: state.isOTPProcessing
              ? null
              : () {
                  if (_oneTimePassword?.length != 6) {
                    errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                    setState(() {
                      otpHasError = true;
                    });
                  } else {
                    context.read<PhoneSignUpBloc>().add(SignUpOtpSubmitted(oneTimePassword: _oneTimePassword));
                  }
                },
          child: state.isOTPProcessing
              ? CircularProgressIndicator()
              : Text(
                  S.current.signUpOTPContinueButton,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
        ),
      );
    });
  }

  Widget centeredScrollView({@required Widget child}) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          constraints: BoxConstraints(maxWidth: 300),
          child: child,
        ),
      ),
    );
  }
}
