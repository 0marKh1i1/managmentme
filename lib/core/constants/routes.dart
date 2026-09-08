import 'package:managementme/Modules/auth/login_screen/bindings/login_binding.dart';
import 'package:managementme/Modules/auth/login_screen/views/login_view.dart';
import 'package:managementme/modules/auth/forgot_password_screen/views/forgot_password_view.dart';
import 'package:managementme/modules/auth/onboarding_screen/viwes/onboarding_view.dart';
import 'package:managementme/modules/auth/signup_screen/bindings/signup_binding.dart';
import 'package:managementme/modules/auth/signup_screen/views/signup_view.dart';
import 'package:managementme/modules/home/home_screen/bindings/home_binding.dart';
import 'package:managementme/modules/home/home_screen/views/home_view.dart';
import 'package:managementme/modules/profile/profile_screen/bindings/profile_binding.dart';
import 'package:managementme/modules/profile/profile_screen/views/profile_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:managementme/modules/home/root/bindings/root_binding.dart';
import 'package:managementme/modules/home/root/views/root_view.dart';

final List<GetPage> appRoutes = [
  GetPage(name: "/", page: () => const OnBoarding()),
  GetPage(name: "/home", page: () => const Home(), binding: HomeBinding()),
  GetPage(name: "/login", page: () => const Login(), binding: LoginBinding()),
  GetPage(name: "/signup", page: () => const SignUp(), binding: SignupBinding()),
  GetPage(name: "/forgotPassword", page: () => const ForgotPassword()),
  GetPage(name: "/profile", page: () => const ProfileView(), binding: ProfileBinding()),
  GetPage(name: "/root", page: () => const RootView(), binding: RootBinding()),
];
