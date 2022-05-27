import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//todo [remove]
class ReloadWidget extends StatelessWidget {
  final Widget content;
  final VoidCallback onPressed;
  final String image;

  ReloadWidget.error({Key key, this.content, this.onPressed})
      : image = "assets/svg/error.svg",
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.03,
        horizontal: size.height * 0.1,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(image, height: size.height * 0.15),
            SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }
}
