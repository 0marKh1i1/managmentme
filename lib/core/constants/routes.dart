import 'package:managementme/Modules/auth/login_screen/bindings/login_binding.dart';
import 'package:managementme/Modules/auth/login_screen/views/login_view.dart';
import 'package:managementme/modules/admin/home/employees_screen/bindings/employees_binding.dart';
import 'package:managementme/modules/admin/home/employees_screen/views/employees_view.dart';
import 'package:managementme/modules/auth/forgot_password_screen/views/forgot_password_view.dart';
import 'package:managementme/modules/auth/onboarding_screen/viwes/onboarding_view.dart';
import 'package:managementme/modules/auth/signup_screen/bindings/signup_binding.dart';
import 'package:managementme/modules/auth/signup_screen/views/signup_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:managementme/modules/admin/home/root/bindings/root_binding.dart';
import 'package:managementme/modules/admin/home/root/views/root_view.dart';

final List<GetPage> appRoutes = [
  GetPage(name: "/", page: () => const OnBoarding()),
  GetPage(name: "/login", page: () => const Login(), binding: LoginBinding()),
  GetPage(name: "/signup", page: () => const SignUp(), binding: SignupBinding()),
  GetPage(name: "/forgotPassword", page: () => const ForgotPassword()),
  GetPage(name: "/root", page: () => const RootView(), binding: RootBinding()),
  GetPage(name: '/admin/employees', page: () => const EmployeesView() , binding: EmployeesBinding()),
];
