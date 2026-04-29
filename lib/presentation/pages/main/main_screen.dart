import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kinbii/theme/app_theme.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: AppTheme.appColors.white,
                borderRadius: BorderRadius.circular(35.r),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.appColors.softGrey.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.arrow_circle_down_outlined,
                    activeIcon: Icons.arrow_circle_down,
                    label: 'Prod In',
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: Icons.arrow_circle_up_outlined,
                    activeIcon: Icons.arrow_circle_up,
                    label: 'Prod Out',
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: 'Setting',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? AppTheme.appColors.primary : AppTheme.appColors.grey;
    final currentIcon = isSelected ? activeIcon : icon;

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(currentIcon, color: color, size: 24.w),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTheme.appTextStyles.bodyXSmall.copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

