import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/firebase_services/firebase_analytics_service.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/lib/home/profile/bloc/profile_bloc.dart';
import 'package:my_spend/lib/home/profile/bloc/profile_event.dart';
import 'package:my_spend/lib/home/profile/bloc/profile_state.dart';
import 'package:my_spend/lib/home/profile/logout/logout_bloc.dart';
import 'package:my_spend/lib/home/profile/personal_info/personal_info_view.dart';
import 'package:my_spend/lib/home/savingGoals/savingGoalsview.dart';
import 'package:my_spend/lib/notification/notificationView.dart';
import 'package:my_spend/services/dynamic_icon_service.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/services/pdf_csv_export_service.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Profileview extends StatelessWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LogoutBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  void _showExportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (bottomSheetContext) {
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
                  "Includes category summary and transaction table",
                ),
                trailing: const Icon(Icons.download),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final user = FirebaseAuthService().currentUser;
                  final uid = user?.uid ?? '';
                  final email = user?.email ?? '';

                  if (uid.isNotEmpty) {
                    final snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('transactions')
                        .get();

                    final file = await PdfCsvExportService.generatePdfReport(
                      userName: email.split('@').first,
                      userEmail: email,
                      transactions: snapshot.docs,
                    );

                    await FirebaseAnalyticsService().logEvent(
                      name: 'export_report',
                      parameters: {'format': 'pdf'},
                    );

                    await PdfCsvExportService.openAndShareFile(
                        file, "MySpend PDF Report");
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: const Text("Export as CSV Sheet"),
                subtitle: const Text("Spreadsheet compatible CSV data format"),
                trailing: const Icon(Icons.download),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final user = FirebaseAuthService().currentUser;
                  final uid = user?.uid ?? '';

                  if (uid.isNotEmpty) {
                    final snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('transactions')
                        .get();

                    final file = await PdfCsvExportService.generateCsvReport(
                      transactions: snapshot.docs,
                    );

                    await FirebaseAnalyticsService().logEvent(
                      name: 'export_report',
                      parameters: {'format': 'csv'},
                    );

                    await PdfCsvExportService.openAndShareFile(
                        file, "MySpend CSV Export");
                  }
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
                parentContext.read<LogoutBloc>().add(LogoutButtonPressed());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuthService().currentUser;

    return MultiBlocListener(
      listeners: [
        BlocListener<LogoutBloc, LogoutState>(
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
              Navigator.of(context, rootNavigator: true).pop();
              context.go('/login');
            } else if (state.postApiStatus == PostApiStatus.error) {
              Navigator.of(context, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.isEmpty ? 'Logout failed' : state.message)),
              );
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.message != null && state.message!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: state.biometricEnabled ? AppColors.Success : AppColors.Error,
                ),
              );
            }
          },
        ),
      ],
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
                  user?.displayName ?? user?.email?.split('@').first ?? "User",
                  style: AppTextStyles.headingLarge,
                ),
                Text(
                  user?.email ?? "",
                  style: AppTextStyles.captionBold,
                ),
                15.ph,
                _buildMenuTile(
                  title: "Personal information",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInfoView(),
                      ),
                    );
                  },
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
                // Biometric App Lock Tile with BLoC
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return Container(
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
                            activeThumbColor: AppColors.primary,
                            value: state.biometricEnabled,
                            onChanged: (val) {
                              context.read<ProfileBloc>().add(ToggleBiometricEvent(val));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                15.ph,
                _buildMenuTile(
                  title: "Change App Icon",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      builder: (ctx) => Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Select App Icon", style: AppTextStyles.headingLarge),
                            20.ph,
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFF5D5FEF),
                                child: Icon(Icons.palette, color: Colors.white),
                              ),
                              title: const Text("Default (Indigo)"),
                              onTap: () {
                                DynamicIconService.changeIcon('default');
                                Navigator.pop(ctx);
                              },
                            ),
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFF1A1A2E),
                                child: Icon(Icons.dark_mode, color: Colors.amber),
                              ),
                              title: const Text("Dark Theme"),
                              onTap: () {
                                DynamicIconService.changeIcon('dark');
                                Navigator.pop(ctx);
                              },
                            ),
                            ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFFF9933),
                                child: Icon(Icons.flag, color: Colors.white),
                              ),
                              title: const Text("Indian Tricolour 🇮🇳"),
                              onTap: () {
                                DynamicIconService.changeIcon('tricolor');
                                Navigator.pop(ctx);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                15.ph,
                _buildMenuTile(
                  title: "Export data",
                  onTap: () => _showExportBottomSheet(context),
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
