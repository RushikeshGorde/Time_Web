//   import 'package:flutter/material.dart';
//   import 'package:go_router/go_router.dart';
// import 'package:time_attendance/screen/auth/LoginPage.dart';
//   // Add login screen
//   import 'package:time_attendance/screen/home_tab_screens/dashboard_screen.dart';
//   import 'package:time_attendance/screen/master_tab_screens/company_screens/main_company_screen.dart';
//   import 'package:time_attendance/screen/master_tab_screens/department_screens/main_department_screen.dart';
//   import 'package:time_attendance/screen/master_tab_screens/designation_screens/main_designation_screen.dart';
//   import 'package:time_attendance/screen/master_tab_screens/holiday_screens/main_holiday_screen.dart';
//   import 'package:time_attendance/screen/master_tab_screens/location_screens/main_location_screen.dart';
//   import 'package:time_attendance/widget/responsive_scaffold.dart';

//   final GoRouter router = GoRouter(
//     initialLocation: '/login', // Set initial route to login
//     routes: [
//       // Login route (outside shell route)
//       GoRoute(
//         path: '/login',
//         builder: (context, state) => const LoginPage(),
//       ),
      
//       // Main shell route with responsive scaffold
//       ShellRoute(
//         builder: (context, state, child) {
//           return ResponsiveScaffold(child: child);
//         },
//         routes: [
//           GoRoute(
//             path: '/',
//             builder: (context, state) => const DashboardScreen(),
//           ),
//           GoRoute(
//             path: '/designation',
//             builder: (context, state) => MainDesignationScreen(),
//           ),
//           GoRoute(
//             path: '/department',
//             builder: (context, state) => MaindepartmentScreen(),
//           ),
//           GoRoute(
//             path: '/company',
//             builder: (context, state) => MainCompanyScreen(),
//           ),
//           GoRoute(
//             path: '/location',
//             builder: (context, state) => MainLocationScreen(),
//           ),
//           GoRoute(
//             path: '/holiday',
//             builder: (context, state) => const MainHolidayScreen(),
//           ),
//         ],
//       ),
//     ],
    
//     // Optional: Add error handling
//     errorBuilder: (context, state) => Scaffold(
//       body: Center(
//         child: Text('Navigation error: ${state.error}'),
//       ),
//     ),
//   );
import 'package:go_router/go_router.dart';
import 'package:time_attendance/screen/auth/LoginPage.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_main_screen.dart';
import 'package:time_attendance/screen/home_tab_screens/dashboard_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/company_screens/main_company_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/department_screens/main_department_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/designation_screens/main_designation_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/holiday_screens/main_holiday_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/location_screens/main_location_screen.dart';
import 'package:time_attendance/widget/responsive_scaffold.dart';

final GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ResponsiveScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => DashboardScreen(),
        ),
        // login
        GoRoute(
          path: '/login', 
          builder: (context, state) => const LoginPage()
          ),
        GoRoute(
          path: '/designation',
          builder: (context, state) => MainDesignationScreen(),
        ),
        GoRoute(
          path: '/department',
          builder: (context, state) => MaindepartmentScreen(),
        ),
        GoRoute(
          path: '/company',
          builder: (context, state) => MainCompanyScreen(),
        ),
        GoRoute(
          path: '/location',
          builder: (context, state) => MainLocationScreen(),
        ),
        GoRoute(
          path: '/holiday',
          builder: (context, state) => MainHolidayScreen(),
        ),
        GoRoute(
          path: '/employee',
          builder: (context, state) => MainEmployeeScreen(),
        ),
      ],
    ),
  ],
);