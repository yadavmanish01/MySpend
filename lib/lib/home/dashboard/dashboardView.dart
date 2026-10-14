import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:my_spend/lib/home/activity/activityView.dart';
import 'package:my_spend/lib/home/budgets/budgetsView.dart';
import 'package:my_spend/lib/home/dashboard/bloc/dashboard_bloc.dart';
import 'package:my_spend/lib/home/dashboard/bloc/dashboard_event.dart';
import 'package:my_spend/lib/home/dashboard/bloc/dashboard_state.dart';
import 'package:my_spend/lib/home/homeview/homeView.dart';
import 'package:my_spend/lib/home/profile/profileView.dart';
import 'package:my_spend/lib/home/scanReceipt/scanReceipt.dart';
import 'package:my_spend/services/localStorage.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: ShowCaseWidget(
        builder: (context) => const _DashboardContent(),
      ),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  final GlobalKey _keyHome = GlobalKey();
  final GlobalKey _keyActivity = GlobalKey();
  final GlobalKey _keyScan = GlobalKey();
  final GlobalKey _keyBudget = GlobalKey();
  final GlobalKey _keyProfile = GlobalKey();

  final List<Widget> _screens = const [
    HomeView(),
    Activityview(),
    Scanreceipt(),
    Budgetsview(),
    Profileview(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkShowcase());
  }

  Future<void> _checkShowcase() async {
    final hasSeen = await LocalStorage().readValue('has_seen_showcase');
    if (hasSeen != 'true' && mounted) {
      ShowCaseWidget.of(context).startShowCase([
        _keyHome,
        _keyActivity,
        _keyScan,
        _keyBudget,
        _keyProfile,
      ]);
      await LocalStorage().setValue('has_seen_showcase', 'true');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: _screens[state.selectedIndex],
            bottomNavigationBar: Stack(
              clipBehavior: Clip.none,
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
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Showcase(
                        key: _keyHome,
                        title: 'Home',
                        description: 'View your total balance, income, and recent transactions.',
                        child: _buildNavItem(context, Icons.home_rounded, "Home", 0, state.selectedIndex),
                      ),
                      Showcase(
                        key: _keyActivity,
                        title: 'Activity',
                        description: 'View weekly/monthly spending charts and export reports.',
                        child: _buildNavItem(context, Icons.bar_chart_rounded, "Activity", 1, state.selectedIndex),
                      ),
                      const SizedBox(width: 56),
                      Showcase(
                        key: _keyBudget,
                        title: 'Budgets',
                        description: 'Track category spending limits and saving goals.',
                        child: _buildNavItem(
                          context,
                          Icons.account_balance_wallet_rounded,
                          "Budget",
                          3,
                          state.selectedIndex,
                        ),
                      ),
                      Showcase(
                        key: _keyProfile,
                        title: 'Profile',
                        description: 'Manage account, biometrics, and exported files.',
                        child: _buildNavItem(context, Icons.person_rounded, "Profile", 4, state.selectedIndex),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -4,
                  child: Showcase(
                    key: _keyScan,
                    title: 'AI Receipt Scanner',
                    description: 'Scan or upload receipts to automatically extract expense details.',
                    child: GestureDetector(
                      onTap: () => context.read<DashboardBloc>().add(const DashboardTabChangedEvent(2)),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, int selectedIndex) {
    final bool isSelected = selectedIndex == index;
    final Color activeColor = AppColors.primary;
    const Color inactiveColor = Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => context.read<DashboardBloc>().add(DashboardTabChangedEvent(index)),
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
