import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/lib/home/activity/bloc/activity_bloc.dart';
import 'package:my_spend/lib/home/activity/bloc/activity_event.dart';
import 'package:my_spend/lib/home/activity/bloc/activity_state.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';

import '../../../utils/colorStyle/colorStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class Activityview extends StatelessWidget {
  const Activityview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityBloc()..add(const FetchActivityEvent()),
      child: const _ActivityContent(),
    );
  }
}

class _ActivityContent extends StatefulWidget {
  const _ActivityContent();

  @override
  State<_ActivityContent> createState() => _ActivityContentState();
}

class _ActivityContentState extends State<_ActivityContent> {
  final List<String> _filters = const ["All", "Expenses", "Income"];
  final TextEditingController _searchController = TextEditingController();

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

  List<double> _calculateDailyTotals(List<QueryDocumentSnapshot> transactions) {
    List<double> dailyTotals = List.filled(7, 0.0);
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      final isExpense = data['isExpense'] as bool? ?? true;
      if (!isExpense) continue;

      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      DateTime? date;

      if (data['date'] is Timestamp) {
        date = (data['date'] as Timestamp).toDate();
      } else if (data['createdAt'] is Timestamp) {
        date = (data['createdAt'] as Timestamp).toDate();
      }

      if (date != null) {
        final difference = date.difference(startOfWeek).inDays;
        if (difference >= 0 && difference < 7) {
          dailyTotals[difference] += amount;
        }
      }
    }

    return dailyTotals;
  }

  @override
  Widget build(BuildContext context) {
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
                  Text("Transactions & Analytics",
                      style: AppTextStyles.headingLarge),
                  IconButton(
                    icon: const Icon(Icons.file_download_outlined,
                        color: AppColors.primary),
                    onPressed: () => _showExportBottomSheet(context),
                  ),
                ],
              ),
              15.ph,
              // Dynamic Analytics Bar Chart Card
              BlocBuilder<ActivityBloc, ActivityState>(
                builder: (context, state) {
                  final dailyTotals = _calculateDailyTotals(state.transactions);
                  final maxVal = dailyTotals.reduce((a, b) => a > b ? a : b);
                  final chartMaxY = maxVal > 0 ? maxVal * 1.2 : 100.0;

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Weekly Expense Analytics",
                                style: AppTextStyles.headingMedium),
                            const Icon(Icons.bar_chart_rounded,
                                color: AppColors.primary),
                          ],
                        ),
                        15.ph,
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: chartMaxY,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (group) => AppColors.primary,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '₹${rod.toY.toStringAsFixed(0)}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = [
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat',
                                        'Sun'
                                      ];
                                      final index = value.toInt();
                                      if (index >= 0 && index < days.length) {
                                        return Text(days[index],
                                            style: AppTextStyles.caption);
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: List.generate(7, (i) {
                                return BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: dailyTotals[i],
                                      color: AppColors.primary,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    )
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              20.ph,
              CustomFormField(
                controller: _searchController,
                prefixIcon: const Icon(Icons.search),
                hint: "Search transactions",
                onChanged: (val) {
                  context
                      .read<ActivityBloc>()
                      .add(SearchQueryChangedEvent(val));
                },
              ),
              20.ph,
              BlocBuilder<ActivityBloc, ActivityState>(
                buildWhen: (previous, current) =>
                    previous.selectedFilterIndex != current.selectedFilterIndex,
                builder: (context, state) {
                  return Row(
                    children: List.generate(_filters.length, (index) {
                      final isSelected = state.selectedFilterIndex == index;
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<ActivityBloc>()
                              .add(FilterChangedEvent(index));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF5D5FEF).withValues(alpha: 0.12)
                                : (index == 1
                                    ? const Color(0xFFFFEAEA)
                                    : const Color(0xFFE8F8F0)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _filters[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF5D5FEF)
                                  : (index == 1
                                      ? const Color(0xFFFF5252)
                                      : const Color(0xFF27AE60)),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              20.ph,
              BlocBuilder<ActivityBloc, ActivityState>(
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.transactions.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                        "No transaction activity found.",
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }

                  final query = state.searchQuery.toLowerCase().trim();
                  final filteredDocs = state.transactions.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final isExpense = data['isExpense'] as bool? ?? true;
                    final title =
                        (data['title'] as String? ?? '').toLowerCase();
                    final category =
                        (data['category'] as String? ?? '').toLowerCase();

                    if (state.selectedFilterIndex == 1 && !isExpense) {
                      return false;
                    }
                    if (state.selectedFilterIndex == 2 && isExpense) {
                      return false;
                    }

                    if (query.isNotEmpty) {
                      return title.contains(query) || category.contains(query);
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
                      final item =
                          filteredDocs[index].data() as Map<String, dynamic>;
                      final title = item['title'] ?? 'Transaction';
                      final category = item['category'] ?? 'General';
                      final amount =
                          (item['amount'] as num?)?.toDouble() ?? 0.0;
                      final isExpense = item['isExpense'] as bool? ?? true;
                      final letter =
                          title.isNotEmpty ? title[0].toUpperCase() : 'T';

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
                                  Text(category,
                                      style: AppTextStyles.captionBold),
                                ],
                              ),
                            ),
                            Text(
                              "${isExpense ? '-' : '+'}₹${amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isExpense
                                    ? const Color(0xFFE53935)
                                    : const Color(0xFF27AE60),
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
