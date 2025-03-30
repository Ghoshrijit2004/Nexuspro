import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'my_network.dart';
import 'video.dart';
import 'notifications.dart';
import 'guild.dart';
import 'profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> games = [
    {
      'name': 'PUBG Mobile',
      'image': 'assets/pubg-logo-background-6ldzn94r2bu0r668.jpg',
      'url': 'https://play.google.com/store/search?q=pubg&c=apps'
    },
    {
      'name': 'Clash of Clans',
      'image': 'assets/coc.jpeg',
      'url':
          'https://play.google.com/store/apps/details?id=com.supercell.clashofclans'
    },
    {
      'name': 'Call of Duty',
      'image': 'assets/Warzone.jpeg',
      'url':
          'https://play.google.com/store/apps/details?id=com.activision.callofduty.shooter'
    },
    {
      'name': 'Genshin Impact',
      'image': 'assets/genshin-impact-version-28_vf5v.1280.webp',
      'url':
          'https://play.google.com/store/apps/details?id=com.miHoYo.GenshinImpact'
    },
    {
      'name': 'Free Fire Max',
      'image': 'assets/GARENA1-1.webp',
      'url': 'https://play.google.com/store/search?q=free%20fire%20max&c=apps'
    },
  ];

  void _openGame(String url) async {
    final Uri gameUrl = Uri.parse(url);
    if (await canLaunchUrl(gameUrl)) {
      await launchUrl(gameUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open link");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Get.offAll(() => const MyHomePage());
        break;
      case 1:
        Get.offAll(() => const MyNetwork());
        break;
      case 2:
        Get.offAll(() => const Video());
        break;
      case 3:
        Get.offAll(() => const Notifications());
        break;
      case 4:
        Get.offAll(() => const Guild());
        break;
    }
  }

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
      body: Column(
        children: [
          const SizedBox(height: 10),

          // ✅ Game images slider
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemCount: games.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _openGame(games[index]['url']!),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(games[index]['image']!,
                          fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),

          // ✅ Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: games.length,
            effect: const ExpandingDotsEffect(
                dotHeight: 8, dotWidth: 8, activeDotColor: Colors.red),
          ),

          const SizedBox(height: 10),

          // ✅ Expanded ListView for posts
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                for (var post in [
                  {
                    'username': 'RGgaming',
                    'caption': 'Great match today!😎',
                    'image': 'assets/Call-of-Duty-Victory-in-Match.jpg'
                  },
                  {
                    'username': 'ProGamerX',
                    'caption': 'Epic clutch moment!🔥',
                    'image': 'assets/pubg-win.jpg'
                  },
                  {
                    'username': 'EsportsChamp',
                    'caption': 'Victory Royale! 🏆',
                    'image': 'assets/fortnite-victory.jpg'
                  },
                  {
                    'username': 'SniperElite',
                    'caption': 'One-shot, one-kill 🎯',
                    'image': 'assets/sniper-shot.jpg'
                  },
                ])
                  Card(
                    margin: const EdgeInsets.all(10),
                    color: Colors.grey[900],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            post['username']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            post['caption']!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Follow button action
                            },
                            child: const Text("Follow"),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            post['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up,
                                    color: Colors.white),
                                onPressed: () {
                                  // Like button action
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.comment,
                                    color: Colors.white),
                                onPressed: () {
                                  // Comment button action
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share,
                                    color: Colors.white),
                                onPressed: () {
                                  // Share button action
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
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
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.red,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: 'My Network'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_call), label: 'Video'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Guild'),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
