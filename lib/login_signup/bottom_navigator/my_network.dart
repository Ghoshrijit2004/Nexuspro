import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'video.dart';
import 'notifications.dart';
import 'guild.dart';
import 'profile.dart';
import 'my_home_page.dart';

class MyNetwork extends StatelessWidget {
  const MyNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 5, 5, 6),
            border: Border.all(
              color: const Color.fromARGB(255, 235, 8, 24), // Neon border color
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 245, 7, 7).withOpacity(0.8),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 4, 3, 5),
            elevation: 0,
            automaticallyImplyLeading: false, // Removes the 3-line menu icon
            title: Row(
              children: [
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () =>
                        Scaffold.of(context).openDrawer(), // Open Drawer
                    child: const CircleAvatar(
                      radius: 18, // Adjusted size
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.message, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),

      // Drawer Section with Dark Purple
      drawer: Drawer(
        backgroundColor:
            const Color.fromARGB(255, 5, 4, 6), // Drawer background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 10, 8, 14), // Drawer header background color
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ), // Profile image
                  ),
                  SizedBox(height: 10),
                  Text(
                    'RGgaming',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Esports Player',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Get.to(
                  () => const ProfilePage(),
                ); // Use Get.to instead of Get.offAll
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),

      body: const Center(child: Text("My Network Page")),

      // Bottom Navigation Bar with consistent neon style
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 13, 13, 14), // Background color
          border: Border.all(
            color: const Color.fromARGB(255, 233, 8, 8), // Neon border color
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 234, 8, 8).withOpacity(0.8),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors
              .transparent, // Transparent so that Container's color is visible
          selectedItemColor:
              const Color.fromARGB(255, 246, 244, 246), // Selected icon color
          unselectedItemColor:
              const Color.fromARGB(255, 231, 9, 9), // Unselected icon color
          currentIndex: 1, // Set correct index for My Home page
          type: BottomNavigationBarType.fixed, // Fix shifting issue
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'My Network',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call),
              label: 'Video',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Guild'),
          ],
          onTap: (index) {
            if (index == 0) {
              Get.offAll(() => const MyHomePage());
            } else if (index == 1) {
              Get.offAll(() => const MyNetwork());
            } else if (index == 2) {
              Get.offAll(() => const Video());
            } else if (index == 3) {
              Get.offAll(() => const Notifications());
            } else if (index == 4) {
              Get.offAll(() => const Guild());
            }
          },
        ),
      ),
    );
  }
}
