import 'package:flutter/material.dart';
import 'package:task_manger/config/constant.dart';
import 'package:task_manger/config/theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,

        height: 200,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 25, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello!', style: AppTextStyles.appTitle),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start your day by doing your\n tasks and habits.',
                    style: AppTextStyles.smallwithoutBold,
                  ),
                  Image.asset('asset/images/data.png', width: 90, height: 80),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
