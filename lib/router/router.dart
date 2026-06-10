import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:vehicle_parts_store/log_in.dart';
import 'package:vehicle_parts_store/HomeScreen.dart';
import 'package:vehicle_parts_store/log_out.dart';
import 'package:vehicle_parts_store/AboutUs.dart';
import 'package:vehicle_parts_store/createpost.dart';
import 'package:vehicle_parts_store/EditProfile.dart';
import 'package:vehicle_parts_store/mainscreen.dart';
import 'package:vehicle_parts_store/search.dart';
import 'package:vehicle_parts_store/mypost.dart';
import 'package:vehicle_parts_store/details.dart';
import 'package:vehicle_parts_store/home2.dart';
import 'package:vehicle_parts_store/menu.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/login",
    routes: [
      // Login/sign-in page
      GoRoute(
        path: "/login",
        builder: (context, state) {
          return LogInScreen();
        },
      ),
      GoRoute(
        path: "/",
        builder: (context, state) {
          return Mainscreen();
        },
      ),

      // Home page
      GoRoute(
        path: "/home",
        builder: (context, state) {
          return HomeScreen();
        },
      ),

      // Logout action
      GoRoute(
        path: "/logout",
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showLogoutDialog(context); // Show the logout dialog
          });
          return const SizedBox.shrink(); // Return an empty widget
        },
      ),
      GoRoute(
          path: "/about",
          builder: (context, state) {
            return AboutUsPage();
          }),

      //create post
      GoRoute(
          path: "/createpost",
          builder: (context, state) {
            return CreatePost();
          }),

      //edit profile
      GoRoute(
          path: "/editprofile",
          builder: (context, state) {
            return EditProfileScreen();
          }),

      // Search page
      GoRoute(
          path: "/search",
          builder: (context, state) {
            return SearchScreen();
          }),

      //mypost
      GoRoute(
          path: "/mypost",
          builder: (context, state) {
            return MyPosts();
          }),

      // Details page
      GoRoute(
        path: "/details",
        builder: (context, state) {
          final post = state.extra as Map<String, dynamic>; // Pass post data
          return PartDetailsPage(post: post);
        },
      ),

      // Home2 page
      GoRoute(
        path: "/home2",
        builder: (context, state) {
          final selectedCategory =
              state.extra as String; // Pass selected category
          return Home2Page(category: selectedCategory);
        },
      ),

      //menu
      GoRoute(
          path: "/Menu",
          builder: (context, state) {
            return Menu();
          }),
    ],
  );
}
