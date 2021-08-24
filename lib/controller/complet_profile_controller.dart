import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/models/uf_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CompletProfileController extends GetxController {
  var nameTEC = TextEditingController();
  var profileNameTEC = TextEditingController();
  var phoneTEC = TextEditingController();
  var birthDayTEC = TextEditingController();
  var cityTEC = TextEditingController();
  var ufTEC = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Sex? sexType;
  RxString sextypeError = ''.obs;
  UfModel? selectedUfModel;
  Uint8List? imageProfile;

  var phoneMask =
      new MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {
    nameTEC.dispose();
    profileNameTEC.dispose();
    phoneTEC.dispose();
    birthDayTEC.dispose();
    cityTEC.dispose();
    ufTEC.dispose();

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

  onPickerDate() async {
    var pickedDate = await showDatePicker(
        initialDatePickerMode: DatePickerMode.year,
        initialEntryMode: DatePickerEntryMode.input,
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(1920),
        lastDate: DateTime.now());
    if (pickedDate == null) return;
    birthDayTEC.text = formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
  }

  onCompletProfile() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (sexType == null) {
      sextypeError.value = 'Escolha um gênero';

      return;
    }
  }

  String? validateUserName(String? value) {
    if (value!.isEmpty) return 'Obrigatório';
    if (value.length < 8) return 'Nome muito curto';
    return null;
  }

  String? validateProfileName(String? value) {
    if (value!.isEmpty) return 'Obrigatório';
    if (value.length < 4) return 'Nome do perfil muito curto';
    if (value.contains(' ')) return 'Nome de Perfil não deve conter espaços';
    return null;
  }

  String? validatePhone(String? value) {
    if (value!.isNotEmpty) {
      if (value.length < phoneMask.getMask()!.length) return 'Telefone Inválido';
    }

    return null;
  }

  String? validateDate(String? value) {}

  String? validateUf(String? value) {}

  String? validateCity(String? value) {
    if (selectedUfModel != null) {
      if (value!.isEmpty) return 'Escolha uma Cidade';
    }
    return null;
  }

  String? validateProfissao(String? value) {}

  void changeSexType(Sex? value) {
    if (value == null) return;
    sexType = value;
    sextypeError.value = '';
    update();
  }
}
