import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:radency_internship_project_2/blocs/login/phone_login/login_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/ui/shared_components/elevated_buttons/colored_elevated_button.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/utils/strings.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.loginToolbarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(context.read<FirebaseAuthenticationService>()),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _otpText = "";
  String _phoneNumber = "";

  TextEditingController? codeController;

  late StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    super.initState();
    if (errorController == null || !errorController!.hasListener) {
      errorController = StreamController<ErrorAnimationType>();
    }
  }

  @override
  void dispose() {
    errorController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
      }
    }, builder: (context, state) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appTitle(),
              appLogo(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                constraints: const BoxConstraints(maxWidth: 500),
                child: () {
                  switch (state.loginPageMode) {
                    case LoginPageMode.Credentials:
                      return Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [phoneNumberInput(context)],
                          ));
                    case LoginPageMode.OTP:
                      return Column(
                        children: [
                          Center(
                            child: RichText(
                              text: TextSpan(
                                  text: S.current.otpPassSendToNumber,
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: _phoneNumber.toString(),
                                        style:
                                            TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextButton(
                              child: Text(
                                S.current.wrongNumber,
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                              onPressed: () {
                                setState(() {
                                  _otpText = '';
                                });
                              },
                            ),
                          ),
                          otpPassInput(context, _phoneNumber)
                        ],
                      );
                  }
                }(),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                constraints: const BoxConstraints(maxWidth: 350),
                child: ColoredElevatedButton(
                  onPressed: () {
                    if (state.isOTPProcessing || state.areDetailsProcessing) {
                      return null;
                    }

                    switch (state.loginPageMode) {
                      case LoginPageMode.Credentials:
                        _formKey.currentState?.save();

                        if (_formKey.currentState?.validate() ?? false) {
                          if (!errorController.isClosed) {
                            print('_PhoneAuthScreenState: !errorController.isClosed');
                            errorController.close();
                          }
                          errorController = StreamController<ErrorAnimationType>();
                          return context.read<LoginBloc>().add(LoginCredentialsSubmitted(phoneNumber: _phoneNumber));
                        }
                        break;
                      case LoginPageMode.OTP:
                        return context.read<LoginBloc>().add(LoginOtpSubmitted(oneTimePassword: _otpText));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Center(child: () {
                      switch (state.loginPageMode) {
                        case LoginPageMode.Credentials:
                          return buttonText(S.current.loginButton);
                        case LoginPageMode.OTP:
                          return buttonText(S.current.confirmButton);
                      }
                    }()),
                  ),
                ),
              ),
              if (state.loginPageMode == LoginPageMode.Credentials) createNewAccount(),
              SizedBox(height: 100),
            ],
          ),
        ),
      );
    });
  }

  Widget phoneNumberInput(context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
      TextFormField(
          initialValue: _phoneNumber.replaceAll('+', ''),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return S.current.enterPhoneNumber;
            }

            if (!RegExp(phoneNumberRegExp).hasMatch(val)) {
              return S.current.incorrectPhoneNumber;
            }

            return null;
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onSaved: (value) => _phoneNumber = '+$value',
          decoration: InputDecoration(
              focusedErrorBorder: getColoredBorder(Colors.red),
              errorBorder: getColoredBorder(Colors.redAccent),
              focusedBorder: getColoredBorder(Colors.grey),
              enabledBorder: getColoredBorder(Colors.grey[300]!),
              prefixText: '+',
              labelText: S.current.yourPhoneNumber)),
    ]);
  }

  Widget otpPassInput(context, _phoneNumber) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: PinCodeTextField(
              appContext: context,
              autoFocus: true,
              length: 6,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                selectedColor: Theme.of(context).colorScheme.secondary,
                selectedFillColor: Colors.blueGrey,
                inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveColor: Theme.of(context).disabledColor,
                activeFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              //autoDisposeControllers: false,
              enableActiveFill: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                setState(() {
                  _otpText = value;
                });
              })),
    ]);
  }

  Widget appTitle() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        child: Text(S.current.appTitle,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 32, fontWeight: FontWeight.bold)));
  }

  Widget appLogo() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.secondary,
      width: 100.0,
      height: 100.0,
      child:
          Center(child: Text('Logo', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
    );
  }

  Widget createNewAccount() {
    return RichText(
      text: TextSpan(
          text: S.current.noAccount,
          style: TextStyle(color: Colors.blueGrey, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
                text: ' ${S.current.createNewAccount}',
                style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushNamed(Routes.signUpPage);
                  })
          ]),
    );
  }

  Widget buttonText(String text) {
    return Text(text, style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white));
  }
}

OutlineInputBorder getColoredBorder(Color color) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color,
      ));
}
