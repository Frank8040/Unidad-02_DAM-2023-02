import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
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
                width: 320,
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
                width: 320,
              ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding / 2),
      ],
    );
  }
}
