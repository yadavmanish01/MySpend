import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';

import '../../utils/colorStyle/colorStyle.dart';
import '../../utils/extensions/sizedboxext.dart';

class Notificationview extends StatefulWidget {
  const Notificationview({super.key});

  @override
  State<Notificationview> createState() => _NotificationviewState();
}

class _NotificationviewState extends State<Notificationview> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Text("Notifications", style: AppTextStyles.headingLarge),
              30.ph,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => 12.ph,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
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
                          child: Icon(Icons.notifications_none_outlined,color: AppColors.primary,)
                        ),
                        14.pw,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Budget alert",
                                style: AppTextStyles.headingLarge,
                              ),
                              4.ph,
                              Text(
                                "Food budget is 80% used.",
                                  style: AppTextStyles.captionBold
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              25.ph
            ],
          ),
        ),
      ),
    );
  }
}
