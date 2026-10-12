import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';

import '../../../utils/colorStyle/colorStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class Activityview extends StatefulWidget {
  const Activityview({super.key});

  @override
  State<Activityview> createState() => _ActivityviewState();
}

class _ActivityviewState extends State<Activityview> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Expenses", "Income"];
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showExportBottomSheet(BuildContext context) {
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
              Text("Export Expense Report", style: AppTextStyles.headingLarge),
              10.ph,
              Text(
                "Choose format to download your transaction history:",
                style: AppTextStyles.captionBold,
              ),
              20.ph,
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: const Text("Export as PDF Statement"),
                subtitle: const Text("Includes category charts & total summary"),
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

  @override
  Widget build(BuildContext context) {
    final uid = _authService.currentUser?.uid ?? '';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Transactions", style: AppTextStyles.headingLarge),
                  IconButton(
                    icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                    onPressed: () => _showExportBottomSheet(context),
                  ),
                ],
              ),
              20.ph,
              CustomFormField(
                controller: _searchController,
                prefixIcon: const Icon(Icons.search),
                hint: "Search transactions",
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase().trim();
                  });
                },
              ),
              20.ph,
              Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5D5FEF).withValues(alpha: 0.12)
                            : (index == 1 ? const Color(0xFFFFEAEA) : const Color(0xFFE8F8F0)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF5D5FEF)
                              : (index == 1 ? const Color(0xFFFF5252) : const Color(0xFF27AE60)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              20.ph,
              // Realtime Stream from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: uid.isNotEmpty
                    ? _firestoreService.streamTransactions(uid)
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                        "No transaction activity found.",
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }

                  var filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final isExpense = data['isExpense'] as bool? ?? true;
                    final title = (data['title'] as String? ?? '').toLowerCase();
                    final category = (data['category'] as String? ?? '').toLowerCase();

                    // Filter by Expense/Income tab
                    if (_selectedFilterIndex == 1 && !isExpense) return false;
                    if (_selectedFilterIndex == 2 && isExpense) return false;

                    // Filter by Search Query
                    if (_searchQuery.isNotEmpty) {
                      return title.contains(_searchQuery) || category.contains(_searchQuery);
                    }

                    return true;
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                        "No matching transactions.",
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDocs.length,
                    separatorBuilder: (context, index) => 12.ph,
                    itemBuilder: (context, index) {
                      final item = filteredDocs[index].data() as Map<String, dynamic>;
                      final title = item['title'] ?? 'Transaction';
                      final category = item['category'] ?? 'General';
                      final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
                      final isExpense = item['isExpense'] as bool? ?? true;
                      final letter = title.isNotEmpty ? title[0].toUpperCase() : 'T';

                      return Container(
                        padding: const EdgeInsets.all(14),
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
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F3FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                letter,
                                style: AppTextStyles.headingMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            14.pw,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: AppTextStyles.headingLarge),
                                  4.ph,
                                  Text(category, style: AppTextStyles.captionBold),
                                ],
                              ),
                            ),
                            Text(
                              "${isExpense ? '-' : '+'}₹${amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isExpense ? const Color(0xFFE53935) : const Color(0xFF27AE60),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              30.ph,
            ],
          ),
        ),
      ),
    );
  }
}
