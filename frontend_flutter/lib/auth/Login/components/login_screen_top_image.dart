import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/title_project.svg",
                width: 250,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/logo_project.svg",
                width: 250,
              ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}