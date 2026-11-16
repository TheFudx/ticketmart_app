// Flutter SDK

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// import '../../../model/home/home_model.dart';
import '../../../providers/home_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../Login/widget/side_drawer.dart';
import '../../invitation/invitation_card_screen.dart';
// import '../../offers/offers.dart';
// import '../../profile/user_profile_screan.dart';
// import '../../show/show_detail.dart';
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

  /*
  // Uncomment when shows section is re-enabled:
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All Shows',
    'Standup Comedy',
    'Trending',
    'Special Events',
  ];

  List<ComedyShow?> _filterShows(List<ComedyShow?> allShows) {
    List<ComedyShow?> list = allShows.where((s) => s != null).toList();

    if (_selectedCategoryIndex == 1) {
      list = list.where((s) =>
        s!.genre.toLowerCase().contains('comedy') ||
        s.genre.toLowerCase().contains('standup')
      ).toList();
    } else if (_selectedCategoryIndex == 2) {
      list = list.where((s) =>
        (double.tryParse(s!.rating) ?? 0) >= 4.0 || s.price > 0
      ).toList();
    }

    return list;
  }
  */

  @override
  void initState() {
    super.initState();
    Future.microtask(
      // ignore: use_build_context_synchronously
      () => Provider.of<HomeProvider>(context, listen: false).fetchData(),
    );
    versionNumb();
  }

  void versionNumb() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        versionNumber = packageInfo.version;
      });
    }
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _selectedIndex == 0
          ? appBar(context: context)
          : (_selectedIndex == 1
              ? AppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0.5,
                  title: Text(
                    AppString.offersTxt,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  centerTitle: true,
                )
              : null),
      endDrawer: SideDrawer(verNumber: versionNumber),
      body: _buildPageView(screenHeight, screenWidth),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPageView(double screenHeight, double screenWidth) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      children: <Widget>[
        _buildHomePage(screenHeight, screenWidth),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          curve: Curves.easeInOut,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_rounded),
              title: const Text(AppString.homeTxt),
              selectedColor: AppColors.primaryColor,
              unselectedColor: AppColors.bookedSeated,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage(double screenHeight, double screenWidth) {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        await Provider.of<HomeProvider>(context, listen: false)
            .fetchData(refresh: true);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Consumer<HomeProvider>(
                    builder: (context, homeProvider, _) {
                      final banner = homeProvider.invitationBanner;
                      return buildVerticalPosterBanner(
                        onTap: () {
                          Get.to(() => InvitationCardScreen(
                                eventSlug: banner?.eventSlug ??
                                    'alphaneon-studioz-slate-revel-CnXina',
                                initialBanner: banner,
                              ));
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /*
  // ── Category Filter Pills & Shows Section (Uncomment when needed) ──
  Widget _buildShowsSection(BuildContext context, double screenHeight, double screenWidth) {
    return Column(
      children: [
        buildCategoryFilterPills(
          categories: _categories,
          selectedIndex: _selectedCategoryIndex,
          onSelect: (index) {
            setState(() {
              _selectedCategoryIndex = index;
            });
          },
        ),
        SizedBox(height: 16.h),
        Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            if (homeProvider.isLoading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionHeader(
                    title: "Live Shows",
                    subtitle: "Handpicked live entertainment for you",
                    count: 0,
                  ),
                  SizedBox(height: 12.h),
                  buildShimmerPlaceholder(),
                  SizedBox(height: 20.h),
                ],
              );
            }

            final filteredShows = _filterShows(homeProvider.comedyShow);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionHeader(
                  title: _selectedCategoryIndex == 0
                      ? "Trending Comedy Shows"
                      : _categories[_selectedCategoryIndex],
                  subtitle: "Book verified seats instantly",
                  count: filteredShows.length,
                ),
                SizedBox(height: 12.h),
                if (filteredShows.isEmpty)
                  buildEmptyState(
                    query: '',
                    onReset: () {
                      setState(() {
                        _selectedCategoryIndex = 0;
                      });
                    },
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: filteredShows.length,
                      itemBuilder: (context, index) {
                        final show = filteredShows[index]!;
                        return buildShowCard(
                          show: show,
                          onTap: () => Get.to(
                            () => ShowDetail(show),
                          ),
                        );
                      },
                    ),
                  ),
                buildTrustFeaturesStrip(),
                SizedBox(height: 16.h),
              ],
            );
          },
        ),
      ],
    );
  }
  */
}

