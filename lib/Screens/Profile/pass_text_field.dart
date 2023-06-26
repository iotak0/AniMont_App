import 'package:anime_mont_test/Screens/signup&login/lognin.dart';
import 'package:anime_mont_test/Screens/signup&login/signup.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => widget.valid(value),
                        onChanged: (value) => setState(() {}),
                        enabled: !SignUpState.loading && !LoginState.loading,
                        //maxLines: 5,
                        style: TextStyle(
                          color: primaryColor,
                          fontFamily: context.currentLocale.toString() == 'ar'
                              ? 'SFPro'
                              : 'Angie',
                        ),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
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
                  child: SvgPicture.string(
                    hidePssword == true
                        ? '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Show</title>
    <g id="Iconly/Light/Show" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Show" transform="translate(2.000000, 4.000000)" stroke="#000000" stroke-width="1.5">
            <path d="M13.1615,8.0531 C13.1615,9.7991 11.7455,11.2141 9.9995,11.2141 C8.2535,11.2141 6.8385,9.7991 6.8385,8.0531 C6.8385,6.3061 8.2535,4.8911 9.9995,4.8911 C11.7455,4.8911 13.1615,6.3061 13.1615,8.0531 Z" id="Stroke-1"></path>
            <path d="M9.998,15.3549 C13.806,15.3549 17.289,12.6169 19.25,8.0529 C17.289,3.4889 13.806,0.7509 9.998,0.7509 L10.002,0.7509 C6.194,0.7509 2.711,3.4889 0.75,8.0529 C2.711,12.6169 6.194,15.3549 10.002,15.3549 L9.998,15.3549 Z" id="Stroke-3"></path>
        </g>
    </g>
</svg>'''
                        : '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Hide</title>
    <g id="Iconly/Light/Hide" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Hide" transform="translate(2.000000, 3.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M7.7606,10.8668 C7.1856,10.2928 6.8356,9.5128 6.8356,8.6378 C6.8356,6.8848 8.2476,5.4718 9.9996,5.4718 C10.8666,5.4718 11.6646,5.8228 12.2296,6.3968" id="Stroke-1"></path>
            <path d="M13.1048,9.1989 C12.8728,10.4889 11.8568,11.5069 10.5678,11.7409" id="Stroke-3"></path>
            <path d="M4.6546,13.9723 C3.0676,12.7263 1.7236,10.9063 0.7496,8.6373 C1.7336,6.3583 3.0866,4.5283 4.6836,3.2723 C6.2706,2.0163 8.1016,1.3343 9.9996,1.3343 C11.9086,1.3343 13.7386,2.0263 15.3356,3.2913" id="Stroke-5"></path>
            <path d="M17.4476,5.4908 C18.1356,6.4048 18.7406,7.4598 19.2496,8.6368 C17.2826,13.1938 13.8066,15.9388 9.9996,15.9388 C9.1366,15.9388 8.2856,15.7988 7.4676,15.5258" id="Stroke-7"></path>
            <line x1="17.887" y1="0.7496" x2="2.113" y2="16.5236" id="Stroke-9"></line>
        </g>
    </g>
</svg>''',
                    height: 20,
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
