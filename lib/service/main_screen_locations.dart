import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Page/Home.dart';
import 'package:watalygold_admin/Page/Knowlege/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/MainKnowlege.dart';
import 'package:watalygold_admin/Page/MainDashborad.dart';
import 'package:watalygold_admin/Page/loginpage.dart';
import 'package:watalygold_admin/Page/registerpage.dart';

class HomeLocation extends BeamLocation<BeamState> {
  HomeLocation(RouteInformation routeInformation) : super(routeInformation);
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
          key: ValueKey('home-${DateTime.now()}'), child: const HomePage()),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/home*'];
}

class baseLocation extends BeamLocation<BeamState> {
  baseLocation(RouteInformation routeInformation) : super(routeInformation);
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
          key: ValueKey('home-${DateTime.now()}'), child: const HomePage()),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['^/(?!login)']; // Exclude '/login' path
}

class LoginLocation extends BeamLocation<BeamState> {
  LoginLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState? state) {
    return [
      const BeamPage(
        key: ValueKey('Login'),
        child: LoginPage(),
        type: BeamPageType.fadeTransition,
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/login*'];
}

class RegisterLocation extends BeamLocation<BeamState> {
  RegisterLocation(RouteInformation routeInformation) : super(routeInformation);
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
          key: ValueKey('Register'),
          child: registerPage(),
          type: BeamPageType.fadeTransition),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/register*'];
}

class DashboardLocation extends BeamLocation<BeamState> {
  DashboardLocation(RouteInformation routeInformation)
      : super(routeInformation);
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
          key: ValueKey('Dashboard'),
          child: MainDash(),
          type: BeamPageType.fadeTransition),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/Dashboard*'];
}

class SettingsLocation extends BeamLocation<BeamState> {
  SettingsLocation(RouteInformation routeInformation) : super(routeInformation);
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
          key: ValueKey('MainKnowledge'),
          child: MainKnowlege(),
          type: BeamPageType.fadeTransition),
    ];
  }

  @override
  List<Pattern> get pathPatterns => [
        '/MainKnowledge*',
      ];
}

class ProfileLocation extends BeamLocation<BeamState> {
  ProfileLocation(RouteInformation routeInformation) : super(routeInformation);
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('AddKnowledge'),
        child: AddKnowlege(),
        type: BeamPageType.fadeTransition,
      ),
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/AddKnowledge*'];
}
