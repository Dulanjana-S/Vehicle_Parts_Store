import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0; // Track the selected index
  String _userName = ''; // Default user name
  String? _profileImageUrl; // Default profile image URL

  final Map<int, String> _pageRoutes = {
    0: '/home',
    1: '/createpost',
    2: '/editprofile',
    3: '/about',
  };

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch user profile on initialization
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          setState(() {
            _userName = data['name'] ?? ''; // Fetch updated name
            _profileImageUrl =
                data['profileImageUrl']; // Fetch updated profile picture
          });
        }
      }
    }
  }

  void _onPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    GoRouter.of(context).push(_pageRoutes[index]!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: const Color.fromARGB(
                  166, 255, 255, 255), // Background color for the main page
            ),
            Row(
              children: [
                NavigationDrawer(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onPageSelected,
                  userName: _userName,
                  profileImageUrl: _profileImageUrl,
                ), // Left-side bar
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final String userName;
  final String? profileImageUrl;

  const NavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userName,
    required this.profileImageUrl,
  });

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20), // Adjusted top spacing
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300], // Placeholder background
                  backgroundImage: widget.profileImageUrl != null
                      ? NetworkImage(widget.profileImageUrl!)
                      : null,
                  child: widget.profileImageUrl == null
                      ? Icon(Icons.person, size: 40, color: Colors.black54)
                      : null,
                ),
                SizedBox(width: 10),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Kanit',
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Image.asset('assets/images/icons/logout.png',
                      width: 24, height: 24),
                  onPressed: () {
                    GoRouter.of(context).push('/logout');
                  },
                ),
              ],
            ),
            SizedBox(height: 40), // Adjusted spacing below the header
            // Navigation Items
            NavItem(
              imagepath: 'assets/images/icons/home.png',
              label: 'Home',
              isSelected: widget.selectedIndex == 0,
              onTap: () {
                widget.onItemTapped(0);
                GoRouter.of(context).push('/home');
              },
            ),
            NavItem(
              imagepath: 'assets/images/icons/create.png',
              label: 'My Post',
              isSelected: widget.selectedIndex == 1,
              onTap: () {
                widget.onItemTapped(1);
                GoRouter.of(context).push('/mypost');
              },
            ),
            NavItem(
              imagepath: 'assets/images/icons/edit.png',
              label: 'Edit Profile',
              isSelected: widget.selectedIndex == 2,
              onTap: () {
                widget.onItemTapped(2);
                GoRouter.of(context).push('/editprofile');
              },
            ),
            NavItem(
              imagepath: 'assets/images/icons/about.png',
              label: 'About',
              isSelected: widget.selectedIndex == 3,
              onTap: () {
                widget.onItemTapped(3);
                GoRouter.of(context).push('/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String imagepath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.imagepath,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15), // Adjusted spacing between items
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(156, 255, 215, 0)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30), // Adjusted border radius
        ),
        child: ListTile(
          leading: Image.asset(imagepath, width: 24, height: 24),
          title: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
