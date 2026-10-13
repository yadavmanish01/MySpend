import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/lib/notification/bloc/notification_bloc.dart';
import 'package:my_spend/lib/notification/bloc/notification_event.dart';
import 'package:my_spend/lib/notification/bloc/notification_state.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';

import '../../utils/extensions/sizedboxext.dart';

class Notificationview extends StatelessWidget {
  const Notificationview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationBloc()..add(const FetchNotificationsEvent()),
      child: const _NotificationContent(),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Notifications", style: AppTextStyles.headingLarge),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              20.ph,
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.notifications.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                        "No notifications yet.",
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.notifications.length,
                    separatorBuilder: (context, index) => 12.ph,
                    itemBuilder: (context, index) {
                      final item = state.notifications[index];
                      final title = item['title'] ?? 'Notification';
                      final desc = item['description'] ?? '';
                      final time = item['time'] ?? '';

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_active_outlined,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            12.pw,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: AppTextStyles.headingMedium),
                                  4.ph,
                                  Text(desc, style: AppTextStyles.caption),
                                  6.ph,
                                  Text(time,
                                      style: AppTextStyles.caption
                                          .copyWith(fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
