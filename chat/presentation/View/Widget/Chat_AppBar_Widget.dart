import 'package:flutter/material.dart';

class MyChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyChatAppBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) => AppBar(
    elevation: 2,
    backgroundColor: const Color(0xfff0f0f0),
    toolbarHeight: 60,
    actions: [
      Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 50,
                )),
            const SizedBox(
              width: 3,
            ),
            const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'چت',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      )
    ],
  );

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}
