import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:evently/core/utils/app_images.dart';
import 'package:evently/view/screens/home/add_event_screen.dart';
import 'package:evently/view/screens/home/tabs/home_tab.dart';
import 'package:evently/view/screens/home/tabs/love_tab.dart';
import 'package:evently/view/screens/home/tabs/map_tab.dart';
import 'package:evently/view/screens/home/tabs/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "HOME_SCREEN";

  HomeScreen({super.key});

  List<Widget> tabs = [HomeTab(), MapTab(), LoveTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: tabs[provider.currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddEventScreen.routeName);
          },
          child: Icon(Icons.add, color: Colors.white, size: 40.r),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // BottomAppBar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.currentIndex,
          selectedItemColor: Colors.white,
          iconSize: 32.r,
          unselectedItemColor: AppColors.bg_color,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            provider.changeTabIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              label: "home".tr(),
              icon: ImageIcon(
                AssetImage(
                  provider.currentIndex == 0
                      ? AppImages.ic_home_filled
                      : AppImages.ic_home,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "map".tr(),
              icon: ImageIcon(
                AssetImage(
                  provider.currentIndex == 1
                      ? AppImages.ic_location_filled
                      : AppImages.ic_location,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "love".tr(),
              icon: ImageIcon(
                AssetImage(
                  provider.currentIndex == 2
                      ? AppImages.ic_love_filled
                      : AppImages.ic_love,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "profile".tr(),
              icon: ImageIcon(
                AssetImage(
                  provider.currentIndex == 3
                      ? AppImages.ic_profile_filled
                      : AppImages.ic_profile,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
