import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:to_do/features/tasks/completed_tasks_screen.dart';
import 'package:to_do/features/home/home_screen.dart';
import 'package:to_do/features/profile/profile_screen.dart';
import 'package:to_do/features/tasks/todo_tasks_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

   final screens = [
    const HomeScreen(),
    const TodoTasksScreen(),
    const CompletedTasksScreen(),
    const ProfileScreen(),
  ];

  final currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[currentIndex.value]),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: currentIndex.value,
          onTap: (index) {
            currentIndex.value = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/home.svg',
                colorFilter: currentIndex.value == 0
                    ? ColorFilter.mode(Color(0xFF15B86C), BlendMode.srcIn)
                    : ColorFilter.mode(Color(0xFFC6C6C6), BlendMode.srcIn),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/tasks.svg',
                colorFilter: currentIndex.value == 1
                    ? ColorFilter.mode(Color(0xFF15B86C), BlendMode.srcIn)
                    : ColorFilter.mode(Color(0xFFC6C6C6), BlendMode.srcIn),
              ),
              label: 'to do',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/completed.svg',
                colorFilter: currentIndex.value == 2
                    ? ColorFilter.mode(Color(0xFF15B86C), BlendMode.srcIn)
                    : ColorFilter.mode(Color(0xFFC6C6C6), BlendMode.srcIn),
              ),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/profile.svg',
                colorFilter: currentIndex.value == 3
                    ? ColorFilter.mode(Color(0xFF15B86C), BlendMode.srcIn)
                    : ColorFilter.mode(Color(0xFFC6C6C6), BlendMode.srcIn),
              ),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
