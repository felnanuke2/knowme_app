import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:knowme/models/uf_model.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';

class CompletProfileController extends GetxController {
  var nameTEC = TextEditingController();
  var profileNameTEC = TextEditingController();
  var phoneTEC = TextEditingController();
  var birthDayTEC = TextEditingController();
  var cityTEC = TextEditingController();
  var ufTEC = TextEditingController();
  var profissaoTEC = TextEditingController();
  UfModel? selectedUfModel;
  Uint8List? imageProfile;

  @override
  void dispose() {
    nameTEC.dispose();
    profileNameTEC.dispose();
    phoneTEC.dispose();
    birthDayTEC.dispose();
    cityTEC.dispose();
    ufTEC.dispose();
    profissaoTEC.dispose();
    super.dispose();
  }

  void onselectUF(UfModel? value) {
    if (value!.sigla == 'null') {
      selectedUfModel = null;
      ufTEC.text = '';
    } else {
      ufTEC.text = value.sigla;
      selectedUfModel = value;
    }
    cityTEC.text = '';
    update();
  }

  void onCitySelected(String value) {
    cityTEC.text = value;
  }

  onImagePfofilePressed() async {
    var image = await ImagePickerBottomSheet.showImagePickerBottomSheet(Get.context!);
    if (image == null) return;
    imageProfile = image;
    update();
  }
}
