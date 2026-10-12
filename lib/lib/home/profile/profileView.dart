import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/lib/home/profile/logout/logout_bloc.dart';
import 'package:my_spend/lib/home/savingGoals/savingGoalsview.dart';
import 'package:my_spend/lib/notification/notificationView.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Profileview extends StatelessWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap the stateful content with BlocProvider here
    return BlocProvider(
      create: (context) => LogoutBloc(),
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  bool _biometricEnabled = true;

  void _showExportBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Export Expense Data", style: AppTextStyles.headingLarge),
              10.ph,
              Text(
                "Choose format to download your transaction history:",
                style: AppTextStyles.captionBold,
              ),
              20.ph,
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: const Text("Export as PDF Statement"),
                subtitle: const Text(
                  "Includes category charts & total summary",
                ),
                trailing: const Icon(Icons.download),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("PDF Report generated!")),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: const Text("Export as CSV Sheet"),
                subtitle: const Text("Spreadsheet compatible data format"),
                trailing: const Icon(Icons.download),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("CSV Data exported!")),
                  );
                },
              ),
              10.ph,
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log Out', style: AppTextStyles.headingLarge),
          content: const Text(
            'Are you sure you want to proceed with this operation?',
            style: AppTextStyles.headingSmall,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: AppTextStyles.headingSmall),
              onPressed: () => dialogContext.pop(),
            ),
            TextButton(
              child: const Text('Yes', style: AppTextStyles.bodyLarge),
              onPressed: () {
                dialogContext.pop();
                parentContext.read<LogoutBloc>().add( LogoutButtonPressed());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state.postApiStatus == PostApiStatus.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const PopScope(
              canPop: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (state.postApiStatus == PostApiStatus.completed) {
          // Dismiss the loading spinner dialog if open
          Navigator.of(context, rootNavigator: true).pop();
          // Navigate to login screen using GoRouter
          context.go('/login');
        } else if (state.postApiStatus == PostApiStatus.error) {
          // Dismiss the loading spinner dialog if open
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.isEmpty ? 'Logout failed' : state.message)),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                10.ph,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Profile", style: AppTextStyles.headingLarge),
                ),
                20.ph,
                const CircleAvatar(radius: 50),
                10.ph,
                Text(
                  FirebaseAuthService().currentUser?.displayName ??
                      FirebaseAuthService().currentUser?.email?.split('@').first ??
                      "User",
                  style: AppTextStyles.headingLarge,
                ),
                Text(
                  FirebaseAuthService().currentUser?.email ?? "",
                  style: AppTextStyles.captionBold,
                ),
                15.ph,
                _buildMenuTile(
                  title: "Personal information",
                  onTap: () {},
                ),
                15.ph,
                _buildMenuTile(
                  title: "Saving Goals",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Savinggoalsview(),
                      ),
                    );
                  },
                ),
                15.ph,
                _buildMenuTile(
                  title: "Notifications",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notificationview(),
                      ),
                    );
                  },
                ),
                15.ph,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Biometric Security", style: AppTextStyles.bodyLarge),
                      Switch(
                        activeColor: AppColors.primary,
                        value: _biometricEnabled,
                        onChanged: (val) {
                          setState(() {
                            _biometricEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                15.ph,
                _buildMenuTile(
                  title: "Appearance",
                  onTap: () {},
                ),
                15.ph,
                _buildMenuTile(
                  title: "Export data",
                  onTap: _showExportBottomSheet,
                ),
                15.ph,
                _buildMenuTile(
                  title: "Log Out",
                  showArrow: false,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.bodyLarge),
            if (showArrow) const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}