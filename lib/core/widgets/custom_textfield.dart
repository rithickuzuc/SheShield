// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final String hintText;
//   final IconData prefixIcon;
//   final bool obscureText;

//   const CustomTextField({
//     super.key,
//     required this.hintText,
//     required this.prefixIcon,
//     this.obscureText = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: Icon(prefixIcon),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {

    return TextField(

      obscureText: _isObscured,

      decoration: InputDecoration(

        hintText: widget.hintText,

        prefixIcon: Icon(widget.prefixIcon),

        suffixIcon: widget.obscureText
            ? IconButton(

                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),

                onPressed: () {

                  setState(() {

                    _isObscured = !_isObscured;

                  });

                },

              )
            : null,
      ),
    );
  }
}