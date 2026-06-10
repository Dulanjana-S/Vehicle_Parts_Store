import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:vehicle_parts_store/menu.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 70, // Add space for the leading icon
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0), // Add left margin
        child: IconButton(
          icon: Image.asset('assets/images/icons/menu.png',
              width: 35, height: 35),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  GoRouter.of(context).go('/menu');
                  return const Menu();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 3.0), // Add horizontal margin
          child: IconButton(
            icon: Image.asset('assets/images/icons/search.png',
                width: 25, height: 25),
            onPressed: () {
              GoRouter.of(context).go('/search');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0), // Add right margin
          child: IconButton(
            icon: Image.asset('assets/images/icons/profile.png',
                width: 35, height: 35),
            onPressed: () {
              GoRouter.of(context).go('/editprofile');
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
