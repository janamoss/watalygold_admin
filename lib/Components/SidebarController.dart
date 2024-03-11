import 'package:get/get.dart';
import 'package:watalygold_admin/Page/Knowlege/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/MainKnowlege.dart';
import 'package:watalygold_admin/Page/MainDashborad.dart';

class SidebarController extends GetxController {
  RxInt index = 0.obs;
  RxBool dropdown = false.obs;

  var pages = [
    MainDash(),
    MainKnowlege(),
    Add_Knowlege(),
    // AddKnowlege(),
    // MainKnowlege(),
    // AddKnowlege(),
  ];
}