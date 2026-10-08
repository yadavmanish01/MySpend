import 'package:flutter/material.dart';
import 'package:my_spend/lib/home/activity/activityView.dart';
import 'package:my_spend/lib/home/budgets/budgetsView.dart';
import 'package:my_spend/lib/home/homeview/homeView.dart';
import 'package:my_spend/lib/home/profile/profileView.dart';
import 'package:my_spend/lib/home/scanReceipt/scanReceipt.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeView(),
    Activityview(),
   Scanreceipt(),
    Budgetsview(),
    Profileview(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,

          ///clipbehaviour.none so that it cannot be cutted if it
          ///takes more height then bottomnavigationbar
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 80,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, "Home", 0),
                  _buildNavItem(Icons.bar_chart_rounded, "Activity", 1),
                  const SizedBox(width: 56),
                  _buildNavItem(
                    Icons.account_balance_wallet_rounded,
                    "Budget",
                    3,
                  ),
                  _buildNavItem(Icons.person_rounded, "Profile", 4),
                ],
              ),
            ),

            Positioned(
              top: -4,
              child: GestureDetector(
                onTap: () => _onItemTapped(2), // Index 2 (Scan)
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final Color activeColor = AppColors.primary;
    const Color inactiveColor = Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            4.ph,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
