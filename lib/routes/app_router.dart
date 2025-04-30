import 'package:auto_route/auto_route.dart';
import '../screens/home_screen.dart';
import '../screens/cart_invite_screen.dart';
import '../screens/invite_landing_page.dart';
import '../screens/product_list_screen.dart';
import '../screens/shared_cart_screen.dart';
import '../screens/confirmation_screen.dart';

part 'app_router.gr.dart'; // This links to the generated file

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  // As part of it's setup, It should extend RootStackRouter

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: CartInviteRoute.page),
    AutoRoute(page: InviteLandingRoute.page),
    AutoRoute(page: ProductListRoute.page),
    AutoRoute(page: SharedCartRoute.page),
    AutoRoute(page: ConfirmationRoute.page),
  ];
}
