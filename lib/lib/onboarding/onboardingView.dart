import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/lib/onboarding/bloc/onboarding_bloc.dart';
import 'package:my_spend/lib/onboarding/bloc/onboarding_event.dart';
import 'package:my_spend/lib/onboarding/bloc/onboarding_state.dart';
import 'package:my_spend/routes/routesName.dart';
import 'package:my_spend/services/localStorage.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/extensions/sizedboxext.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: const _OnboardingContent(),
    );
  }
}

class _OnboardingContent extends StatefulWidget {
  const _OnboardingContent();

  @override
  State<_OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<_OnboardingContent> {
  final PageController _pageController = PageController();

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      title: "Track Expenses & Income",
      description:
          "Effortlessly log daily transactions and view real-time, interactive, color-coded financial-analytics.",
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF6C5CE7),
    ),
    OnboardingItem(
      title: "Smart AI Receipt Scanner",
      description:
          "Scan paper receipts using AI. Automatically extract merchant, date, and amount without typing.",
      icon: Icons.document_scanner_outlined,
      color: Color(0xFF00CEC9),
    ),
    OnboardingItem(
      title: "Set Budgets & Save",
      description:
          "Stay on top of your financial goals with customizable, set-limits and 1-click PDF or CSV exports.",
      icon: Icons.pie_chart_outline_rounded,
      color: Color(0xFF00B894),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await LocalStorage().setValue('onboarding_completed', 'true');
    if (mounted) {
      context.goNamed(Routesname.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                // Top Bar: Skip Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("MySpend", style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
                      if (state.currentPage < _pages.length - 1)
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            "Skip",
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),

                // PageView content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      context.read<OnboardingBloc>().add(OnboardingPageChangedEvent(index));
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final item = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: item.color.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item.icon,
                                size: 70,
                                color: item.color,
                              ),
                            ),
                            40.ph,
                            Text(
                              item.title,
                              style: AppTextStyles.headingLarge.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            16.ph,
                            Text(
                              item.description,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8,
                      width: state.currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: state.currentPage == index ? AppColors.primary : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                30.ph,

                // Bottom Navigation / Action Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      if (state.currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    child: Text(
                      state.currentPage == _pages.length - 1 ? "Get Started" : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
