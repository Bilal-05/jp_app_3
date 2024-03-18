// Mainmenu View Logic in here

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:jp_app/app/app.locator.dart';
import 'package:jp_app/app/app.router.dart';
import 'package:jp_app/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainMenuVM extends BaseViewModel {
  final dialogService = locator<DialogService>();
  final navigationService = locator<NavigationService>();
  Services services = locator<Services>();
  bool skipEstimation = false;
  String? service;

  init() async {
    final user = FirebaseAuth.instance.currentUser;
    log(user?.uid.toString() ?? 'null');
  }

  // checkData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   skipEstimation = prefs.getBool('skipEstimation') ?? skipEstimation;
  //   service = prefs.getString('serviceName')!;
  //   log(skipEstimation.toString());
  //   log(service.toString());
  //   notifyListeners();
  // }

  // fetchData() async {
  //   await checkData();
  // }

  setFalse() {
    dialogService
        .showConfirmationDialog(
      title: 'Logout',
      description: 'Are you sure you want to logout?',
      cancelTitle: 'No',
      confirmationTitle: 'Yes',
    )
        .then(
      (value) {
        if (value!.confirmed) {
          eraseData();
          log('erased');
          navigationService.replaceWithStartView();
        } else {
          log('not erased');
        }
      },
    );
  }

  navigateToEstimation(serviceName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // log(service!);
    // log(serviceName);
    // log(skipEstimation.toString());
    // log(prefs.getString('serviceName') ?? 'null');
    // log(prefs.getBool('skipEstimation').toString() ??
    //     skipEstimation.toString());
    // log(prefs.getStringList('service').toString() ?? 'null');
    if (prefs.getStringList('service')!.contains(serviceName)) {
      navigationService.navigateToAppointmentView(service: serviceName);
    } else {
      navigationService.navigateToEstimationView(serviceName: serviceName);
    }
  }

  eraseData() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLogin');
    prefs.remove('documentID');
  }
}
