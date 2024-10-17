import 'package:go_router/go_router.dart';
import 'package:zero_waste/screens/binManagement/assign_route.dart';
import 'package:zero_waste/screens/binManagement/bin_view_screen.dart';
import 'package:zero_waste/screens/binManagement/create_bin_screen.dart';
import 'package:zero_waste/screens/binManagement/create_route_screen.dart';
import 'package:zero_waste/screens/garbageCollection/record_garage_entry_user_screen.dart';
import 'package:zero_waste/screens/garbageCollection/user_history_screen.dart';
import 'package:zero_waste/screens/home_screen.dart';
import 'package:zero_waste/screens/onBoarding_screen.dart';
import 'package:zero_waste/screens/rewardingSystem/item_dashboard.dart';
import 'package:zero_waste/screens/rewardingSystem/manage_points.dart';
import 'package:zero_waste/screens/inquiryManagement/all_analysis.dart';
import 'package:zero_waste/screens/inquiryManagement/updateInquiries/update_binAndPickups_i.dart';
import 'package:zero_waste/screens/inquiryManagement/updateInquiries/update_extraTrash_i.dart';
import 'package:zero_waste/screens/inquiryManagement/updateInquiries/update_normal_i.dart';
import 'package:zero_waste/screens/inquiryManagement/waste_analysis.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_add_binAndPickups.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_add_extratrash.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_add_normal.dart';
import 'package:zero_waste/screens/inquiryManagement/inquiry_dashboard.dart';
import 'package:zero_waste/screens/inquiryManagement/view_inquiries.dart';
import 'package:zero_waste/screens/rewardingSystem/manage_rewards_screen.dart';
import 'package:zero_waste/screens/rewardingSystem/rewards_gift.dart';
import 'package:zero_waste/screens/userManagement/add_employee_screen.dart';
import 'package:zero_waste/screens/userManagement/login_screen.dart';
import 'package:zero_waste/screens/splash_screen.dart';
import 'package:zero_waste/screens/userManagement/register_screen.dart';
import 'package:zero_waste/screens/userManagement/user_dashboard_screen.dart';
import 'package:zero_waste/screens/userManagement/user_update_screen.dart';
import '../notification_listener.dart';
import '../screens/smartbin/garbage_level.dart';
import '../screens/smartbin/qr_genarator.dart';
import '../screens/smartbin/qr_scanner.dart';

import '../models/user.dart';



class AppRouter {
  static final router = GoRouter(
    routes: [
      //General Routes
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/onboard', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

      //User Management Routes
      GoRoute(path: '/user/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/user/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: '/user/update',
          builder: (context, state) => const UserUpdateScreen()),
      GoRoute(
          path: '/employee/register',
          builder: (context, state) => const AddEmployeeScreen()),

      //Bin Management Routes
      GoRoute(path: '/bin/view', builder: (context, state) => BinViewScreen(loginedUser: User(email: '', password: ''))),
      GoRoute(
          path: '/bin/create', builder: (context, state) => const CreateBinScreen()),
      GoRoute(
          path: '/route/create', builder: (context, state) => const CreateRouteScreen()),
      GoRoute(
          path: '/route/assign', builder: (context, state) => const AssignRoute()),

      //Garbage Collection Routes
      GoRoute(
          path: '/collection/entry',
          builder: (context, state) => const RecordGarbageEntryScreen()),
      GoRoute(
          path: '/collection/history',
          builder: (context, state) => const UserHistoryScreen()),

      //Reward Management Routes
      GoRoute(
          path: '/reward/manage',
          builder: (context, state) => const ManageRewardsScreen()),
      GoRoute(
          path: '/reward/points',
          builder: (context, state) => const PointsCreateScreen()),
      GoRoute(
          path: '/reward/gifts',
          builder: (context, state) => const RewardsGiftScreen()),
      GoRoute(
          path: '/reward/items',
          builder: (context, state) => const AdminDashboard()),

      GoRoute(
          path: '/profile',
          builder: (context, state) => const UserDashboardScreen()),
      //smartbin level routes
      GoRoute(
          path: '/smartbin/garabagelevel',
          builder: (context, state) => GarbageLevelPage()),
      GoRoute(
          path: '/smartbin/qrgenarate',
          builder: (context, state) => QrGenerate()),
      GoRoute(
          path: '/smartbin/qrscanner',
          builder: (context, state) => QRScanPage()),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => NotificationListener(),
      ),

      //Garbage Assistant ROutes
      GoRoute(
        path: '/inquiry',
        builder:(context, state) => const InquiryDashboardScreen() ),
      GoRoute(
        path: '/inquiry/add_normal_inquiry',
        builder:(context, state) => const InquiryAddScreen() ),
      GoRoute(
        path: '/inquiry/add_extratrash_pickups',
        builder:(context, state) => const InquiryAddExtraPickupScreen() ),
      GoRoute(
        path: '/inquiry/add_collection_issues',
        builder:(context, state) => const InquiryAddBinCollectionIssuesScreen() ),
      GoRoute(
        path: '/inquiry/daily_analysis',
        builder:(context, state) => const WasteAnalysisScreen() ),
      GoRoute(
        path: '/inquiry/view',
        builder:(context, state) => const InquiryViewScreen() ),
      GoRoute(
        path: '/inquiry/daily_analysis/analysis',
        builder:(context, state) => const AllAnalysisScreen() ),
      GoRoute(
        path: '/inquiry/u_normal_inquiry/:inquiryID',
        builder: (context, state) {
          final inquiryID = state.pathParameters['inquiryID']!;
          return UpdateNormalInquiryScreen(inquiryID: inquiryID);
        },
      ),
      GoRoute(
        path: '/inquiry/u_extra_trash_inquiry/:inquiryID',
        builder: (context, state) {
          final inquiryID = state.pathParameters['inquiryID']!;
          return UpdateExtraTrashInquiriesScreen(inquiryID: inquiryID);
        },
      ),
      GoRoute(
        path: '/inquiry/u_pickup_inquiry/:inquiryID',
        builder: (context, state) {
          final inquiryID = state.pathParameters['inquiryID']!;
          return UpdateBinAndPickupScreen(inquiryID: inquiryID);
        },
      ),



    ],
  );
}
