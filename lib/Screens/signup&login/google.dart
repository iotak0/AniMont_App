import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Google extends StatefulWidget {
  const Google({super.key});

  @override
  State<Google> createState() => _GoogleState();
}

class _GoogleState extends State<Google> {
  final GoogleSignIn google = GoogleSignIn();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String avatar = '';
    String name = '';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () async {
                  await google.signIn().then((value) => {
                        name = value!.displayName.toString(),
                        avatar = value.photoUrl.toString(),
                      });
                  setState(() {});
                },
                child: Container(
                  child: Text('Sign In'),
                )),
            Text(name),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                avatar,
              ),
            )
          ],
        ),
      ),
    );
  }
}
