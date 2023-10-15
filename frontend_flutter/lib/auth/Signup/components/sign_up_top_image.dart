import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/title_project.svg",
                width: 200,
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
                width: 200,
              ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
