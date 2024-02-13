import 'package:get/get.dart';
import 'package:watalygold_admin/Page/Knowlege/AddKnowlege.dart';
import 'package:watalygold_admin/Page/addknowlege.dart';


class SidebarController extends GetxController {
  RxInt index = 0.obs;
  RxBool dropdown = false.obs;

  var pages = [
    Add_Knowlege(),
    Add_Knowlege(),
    AddKnowlege(),
    // MainKnowlege(),
    // AddKnowlege(),
  ];
}
