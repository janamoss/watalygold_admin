import 'package:get/get.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Contentcol.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditMutiple.dart';
import 'package:watalygold_admin/Page/Knowlege/Home.dart';
import 'package:watalygold_admin/Page/Knowlege/HomeKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/mainKnowlege.dart';
import 'package:watalygold_admin/Widgets/ExpansionTile.dart';



class SidebarController extends GetxController {
  RxInt index = 0.obs;
  RxBool dropdown = false.obs;

  var pages = [
    // AddKnowlege(),
    // Multiplecontent(),

   KnowledgeMain(),
    Add_Knowlege(),
    
    HomeKnowledgeMain(),
    // AddKnowlege(),
    // MainKnowlege(),
    // AddKnowlege(),
  ];
}
