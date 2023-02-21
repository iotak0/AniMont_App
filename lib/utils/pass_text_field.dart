import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';

class PassTextFeild extends StatefulWidget {
  const PassTextFeild({
    Key? key,
    required this.passwordController,
    required this.password,
    required this.valid,
  }) : super(key: key);

  final TextEditingController passwordController;
  final String? Function(String?) valid;

  final String password;
  @override
  State<PassTextFeild> createState() => _PassTextFeildState();
}

class _PassTextFeildState extends State<PassTextFeild> {
  bool hidePssword = true;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color iconTheme = Theme.of(context).iconTheme.color!;
    final Color textColor = Color.fromARGB(255, 160, 146, 167);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Container(
        //constraints: BoxConstraints(minHeight: 50),
        //height: 50,
        decoration: BoxDecoration(
          //   border: widget.passwordController.text.isNotEmpty &&
          //           widget.passwordController.text.length < 5
          //       ? Border.all(width: 1, color: primaryColor)
          //       : null,
          color: iconTheme,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) => widget.valid(value),
                        //maxLines: 5,
                        style: TextStyle(
                          color: primaryColor,
                          fontFamily: context.currentLocale.toString() == 'ar'
                              ? 'SFPro'
                              : 'Angie',
                        ),

                        keyboardType: TextInputType.visiblePassword,
                        controller: widget.passwordController,
                        obscureText: hidePssword,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9!$%*@_?&+-]'))
                        ],
                        decoration: InputDecoration(
                          hintText: widget.password,
                          hintStyle: TextStyle(color: primaryColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    if (hidePssword == true) {
                      setState(() {
                        hidePssword = false;
                      });
                    } else
                      setState(() {
                        hidePssword = true;
                      });
                  },
                  child: ImageIcon(
                    AssetImage(hidePssword == true
                        ? 'images/Light/Show.png'
                        : 'images/Light/Hide.png'),
                    size: 20,
                    color: primaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
