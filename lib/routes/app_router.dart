import 'package:auto_route/auto_route.dart';
import '../screens/home_screen.dart';
import '../screens/cart_invite_screen.dart';
import '../screens/invite_landing_page.dart';
import '../screens/product_list_screen.dart';
import '../screens/shared_cart_screen.dart';
import '../screens/confirmation_screen.dart';

part 'app_router.gr.dart'; // Ensure this line exists

@AutoRouterConfig()
class AppRouter extends _$AppRouter { // Make sure it extends _$AppRouter

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