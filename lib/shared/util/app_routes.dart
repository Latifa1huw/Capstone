import 'package:flutter/material.dart';
import 'package:template/features/admin/start/admin_start_page.dart';
import 'package:template/features/authentication/login/login_page.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/authentication/profile_page.dart';
import 'package:template/features/authentication/register/admin_register_page.dart';
import 'package:template/features/authentication/register/customer_register_page.dart';
import 'package:template/features/authentication/register/salon_register_page.dart';
import 'package:template/features/customer/shop/widgets/AppointmentConfirmation.dart';
import 'package:template/features/customer/start/customer_start_page.dart';
import 'package:template/features/salon/coupons/coupon_viewModel.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/coupons/widgets/add_coupon_page.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/features/salon/services/service_viewModel.dart';
import 'package:template/features/salon/services/widgets/add_service_page.dart';
import 'package:template/features/salon/start/salon_start_page.dart';
import 'package:template/features/splash/splash_page.dart';
import 'package:template/features/toggleBetweenUsers/toggle_between_users.dart';

class AppRoutes {
  static const String splashScreen = "splashScreen";
  static const String toggleBetweenUsers = "toggleBetweenUsers";
  static const String loginPage = "loginPage";
  static const String adminRegisterPage = "adminRegisterPage";
  static const String salonRegisterPage = "salonRegisterPage";
  static const String customerRegisterPage = "customerRegisterPage";
  static const String customerStartPage = "customerStartPage";
  static const String salonStartPage = "salonStartPage";
  static const String adminStartPage = "adminStartPage";
  static const String profilePage = "profilePage";
  static const String addServicePage = "addServicePage";
  static const String addCouponPage = "addCouponPage";
  static const String appointmentConfirmation = "appointmentConfirmation";

  static Route<dynamic> appRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return appPage(AnimatedCircleScreen());
      case toggleBetweenUsers:
        return appPage(const ToggleBetweenUsers());
      case loginPage:
        return appPage(LoginPage(type: args as int,));
      case adminRegisterPage:
        return appPage(AdminRegisterPage(user: args as User?,));
      case salonRegisterPage:
        return appPage(SalonRegisterPage(user: args as User?,));
      case customerRegisterPage:
        return appPage(CustomerRegisterPage(user: args as User?,));
      case salonStartPage:
        return appPage(const SalonStartPage());
      case customerStartPage:
        return appPage(const CustomerStartPage());
      case adminStartPage:
        return appPage(const AdminStartPage());
      case profilePage:
        return appPage(const ProfilePage());
      case appointmentConfirmation:
        return appPage(const AppointmentConfirmation());
      case addServicePage:
        return appPage(AddServicePage(viewModel: (args as List)[0] as ServiceViewModel, service: (args as List).length<2 ? null : (args as List)[1] as Service?,));
      case addCouponPage:
        return appPage(AddCouponPage(viewModel: (args as List)[0] as CouponViewModel, coupon: (args as List).length<2 ? null : (args as List)[1] as Coupon?,));
      default:
        return appPage(AnimatedCircleScreen());
    }
  }

  static appPage(Widget page) {
    return MaterialPageRoute(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: page,
        );
      },
    );
  }
}
