import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/views/Login/login_screen.dart';
import 'package:ticketmart/views/show/widget/show_widget.dart';
import '../../../providers/user_provider.dart';
import '../../../repository/auth/login.dart';
import '../../../storage/shared_pref_helper.dart';
import '../../home/drawer/about_page.dart';
import '../../home/drawer/contact_page.dart';
import '../../home/drawer/privacy_page.dart';

class SideDrawer extends StatelessWidget {
  final String verNumber;
  const SideDrawer({super.key, required this.verNumber});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final userMobile = user?.mobile == null ? "" : "+91 ${user!.mobile}";
    final userEmail = user?.email == null ? "" : "Email: ${user?.email}";

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userMobile),
            accountEmail: Text(userEmail),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
          ),
          drawerItem(Icons.home, "Home", () => Get.back()),
          drawerItem(
              Icons.info, "About", () => Get.to(() => const AboutPage())),
          drawerItem(Icons.contact_page_outlined, "Contact",
              () => Get.to(() => const ContactPage())),
          drawerItem(Icons.privacy_tip, "Privacy Policy",
              () => Get.to(() => const PrivacyPage())),
          drawerItem(Icons.logout, "Log Out", logOut),
          gap10,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('v$verNumber'),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }

  Widget drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> logOut() async {
    await LoginRespository.logOut();
    await SharedPrefHelper.logOut();
    Get.offAll(() => const LoginScreen()); // Clears navigation stack
  }
}
