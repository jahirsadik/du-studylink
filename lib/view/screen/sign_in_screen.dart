import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dustudylink/controller/authentication.dart';
import 'package:dustudylink/theme/constants.dart';
import 'package:dustudylink/view/component/google_sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Padding(
            padding: globalEdgeInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                loginScreen(context),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Error initializing Firebase');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return const GoogleSignInButton();
                      }
                      return const SpinKitCubeGrid(
                          size: 50.0, color: Colors.white);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget loginScreen(BuildContext context) {
  if (MediaQuery.of(context).size.width > 1200) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.color),
          child: Image.asset(
            'assets/start.png',
            width: MediaQuery.of(context).size.width / 2,
            // scale: max(MediaQuery.of(context).size.width / 1000, 0.8),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 50),
              Text(
                'Welcome to DUStudyLink!',
                style: Theme.of(context).textTheme.headline2!.apply(
                      color: Colors.white,
                      fontSizeFactor: MediaQuery.of(context).size.width / 1200,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Please log in or sign up using your Google account to continue.',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .apply(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    ));
  } else {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor, BlendMode.color),
              child: Image.asset(
                'assets/start.png',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to DUStudyLink!',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .apply(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Please log in or sign up using your Google account to continue.',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .apply(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
