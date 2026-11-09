import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AchievedTasksWidget extends StatelessWidget {
  const AchievedTasksWidget({
    super.key,
    required RxDouble percentage,
    required RxInt totalDoneTasks,
    required RxInt totalTasks,
  }) : _percentage = percentage,
       _totalDoneTasks = totalDoneTasks,
       _totalTasks = totalTasks;
  final RxDouble _percentage;
  final RxInt _totalDoneTasks, _totalTasks;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'Achieved Tasks',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          subtitle: Obx(() {
            return Text(
              '$_totalDoneTasks Out of $_totalTasks Done',

              // style:
              // Theme.of(context).textTheme.displaySmall!.copyWith(color: Color(0xFFC6C6C6))
            );
          }),
          trailing: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: Obx(() {
                    return CircularProgressIndicator(value: _percentage.value);
                  }),
                ),
              ),
              Obx(() {
                return Text(
                  '${(_percentage * 100).toInt()}%',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
