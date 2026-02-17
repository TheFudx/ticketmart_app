// Flutter SDK

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:ticketmart/views/offers/offers.dart';
import 'package:ticketmart/views/Login/widget/side_drawer.dart';
import 'package:ticketmart/views/show/widget/show_widget.dart';

import '../../../providers/home_provider.dart';
import '../../../repository/home_respository.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_string.dart';
import '../../profile/user_profile.dart';
import '../../show/show_detail.dart';
import 'widget/home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String versionNumber = '';

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    HomeRespository.appVersionChecker(context);
    Future.microtask(
        // ignore: use_build_context_synchronously
        () => Provider.of<HomeProvider>(context, listen: false).fetchData());
    versionNumb();
  }

  void versionNumb() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionNumber = packageInfo.version;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double screenHeight = mediaQuery.height;
    double screenWidth = mediaQuery.width;

    return Scaffold(
      appBar: appBar(),
      endDrawer: SideDrawer(verNumber: versionNumber),
      body: _buildPageView(screenHeight, screenWidth),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPageView(double screenHeight, double screenWidth) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      children: <Widget>[
        _buildHomePage(screenHeight, screenWidth),
        const OffersScreen(),
        const UserProfile(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return SalomonBottomBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        _pageController.jumpToPage(index);
        _selectedIndex = index;
      },
      backgroundColor: Colors.grey[350],
      curve: Curves.easeInOut,
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text(AppString.homeTxt),
          selectedColor: Colors.purple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.local_offer),
          title: const Text(AppString.offersTxt),
          selectedColor: Colors.green,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text(AppString.profileTxt),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildHomePage(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gap10,
          buildImageContainer(
            AppAssets.movieBanner,
            width: MediaQuery.of(context).size.width * 0.98,
            height: screenHeight * 0.20,
          ),
          gap10,
          Text("Comedy Show".padLeft(15),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: screenWidth * 0.02,
                  mainAxisSpacing: screenWidth * 0.02,
                  childAspectRatio: 0.6,
                ),
                itemCount: homeProvider.comedyShow.length,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final data = homeProvider.comedyShow[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Get.to(
                          () => ShowDetail(data),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: data!.imagePath,
                            fit: BoxFit.fill,
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.21,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 9,
                        ),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
