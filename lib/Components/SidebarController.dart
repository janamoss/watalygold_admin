import 'package:get/get.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Home.dart';
import 'package:watalygold_admin/Page/Knowlege/HomeKnowlege.dart';



class SidebarController extends GetxController {
  RxInt index = 0.obs;
  RxBool dropdown = false.obs;

  var pages = [
    // AddKnowlege(),
    Add_Knowlege(),
    HomeKnowlege(),
    
    // AddKnowlege(),
    // MainKnowlege(),
    // AddKnowlege(),
  ];
}
