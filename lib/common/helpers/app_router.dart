import 'package:auto_route/auto_route.dart';
import 'package:legal_defender/common/helpers/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: MainRoute.page, children: [
          AutoRoute(page: HomeRoute.page),
          AutoRoute(page: ChatsRoute.page),
          AutoRoute(page: DocumentsRoute.page),
          AutoRoute(page: AttorneysRoute.page),
          AutoRoute(page: AccountRoute.page)
        ]),
        AutoRoute(page: NotificationsRoute.page),
      ];
}
