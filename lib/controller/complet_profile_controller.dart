import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/constants/constant_UF_and_citys.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/uf_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/main_screen/main_screen.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CompletProfileController extends GetxController {
  bool profileIsComplet = false;
  CompletProfileController(
      {required this.repository,
      required this.userAuthrepository,
      ThirdPartUserDataModel? dataModel}) {
    profileIsComplet = userAuthrepository.currentUser?.profileComplet ?? false;
    if (!profileIsComplet) {
      userAuthrepository.currentUser?.birthDay = dataModel?.birthDay == null
          ? null
          : formatDate(dataModel!.birthDay!, [dd, '/', mm, '/', yyyy]);
      userAuthrepository.currentUser?.sex = dataModel?.gender;
      userAuthrepository.currentUser?.phoneNumber = dataModel?.phoneNumber;
    }
    _setFieldsFromUserModel();
  }

  _setFieldsFromUserModel() async {
    if (userAuthrepository.currentUser != null) {
      nameTEC.text = userAuthrepository.currentUser!.completName ?? '';
      phoneTEC.text = userAuthrepository.currentUser!.phoneNumber ?? '';
      birthDayTEC.text = userAuthrepository.currentUser!.birthDay ?? '';
      sexType = userAuthrepository.currentUser!.sex;
      if (profileIsComplet) {
        final user = userAuthrepository.currentUser!;
        profileNameTEC.text = user.profileName ?? '';
        phoneTEC.text = user.phoneNumber ?? '';
        birthDayTEC.text = user.birthDay ?? '';
        ufTEC.text = user.uf ?? '';
        bioTEC.text = user.bio ?? '';
        if (user.uf != null) {
          selectedUfModel =
              BRAZILIAN_CITYS_JSON.firstWhere((element) => element?.sigla.toUpperCase() == user.uf);
        }
        cityTEC.text = user.city ?? '';
        sexType = user.sex;
      }
    }
  }

  final DbRepositoryInterface repository;
  final UserAuthInterface userAuthrepository;

  final nameTEC = TextEditingController();
  final profileNameTEC = TextEditingController();
  final phoneTEC = TextEditingController();
  final birthDayTEC = TextEditingController();
  final cityTEC = TextEditingController();
  final ufTEC = TextEditingController();
  final bioTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Sex? sexType;
  final RxString sextypeError = ''.obs;
  final loadingProfileImage = false.obs;
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
    var image =
        await ImagePickerBottomSheet.showImagePickerBottomSheet(Get.context!, circular: true);
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

  onCompletProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (sexType == null) {
      sextypeError.value = 'Escolha um gênero';

      return;
    }
    if (!profileIsComplet) {
      _callErrorSnackBar(title: 'Validando Dados', message: '', failure: false);
      userAuthrepository.currentUser?.birthDay = birthDayTEC.text;
      userAuthrepository.currentUser?.city = cityTEC.text;
      userAuthrepository.currentUser?.uf = ufTEC.text;
      userAuthrepository.currentUser?.uf = ufTEC.text;
      userAuthrepository.currentUser?.completName = nameTEC.text;
      userAuthrepository.currentUser?.bio = '';

      userAuthrepository.currentUser?.phoneNumber = phoneTEC.text;

      userAuthrepository.currentUser?.profileName = profileNameTEC.text;
      userAuthrepository.currentUser?.profileComplet = true;
      userAuthrepository.currentUser?.sex = sexType;

      try {
        if (imageProfile != null) {
          final imagURl = await repository.upLoadImage(
              imageByte: imageProfile!, userID: userAuthrepository.currentUser!.id!);
          userAuthrepository.currentUser?.profileImage = imagURl;
        }

        await repository.createUser(userAuthrepository.currentUser!);
        if (!userAuthrepository.currentUserdataCompleter.isCompleted)
          userAuthrepository.currentUserdataCompleter.complete();
        Get.offAll(() => MainScreen());
      } on RequestError catch (e) {
        _callErrorSnackBar(title: 'Erro ao Completar o Perfil', message: e.message ?? '');
      }
    } else {
      try {
        final responseUser = await repository.updateUser(userAuthrepository.currentUser!.id!,
            birthDay: birthDayTEC.text,
            city: cityTEC.text,
            completName: nameTEC.text,
            phoneNumber: phoneTEC.text,
            profileName: profileNameTEC.text,
            sex: sexType.toString(),
            uf: ufTEC.text,
            bio: bioTEC.text);
        userAuthrepository.currentUser = responseUser..profileComplet = true;
        Get.back(result: responseUser);
      } on RequestError catch (e) {
        _callErrorSnackBar(title: 'Erro ao Completar o Perfil', message: e.message ?? '');
      }
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

  void changeSexType(Sex? value) {
    if (value == null) return;
    sexType = value;
    sextypeError.value = '';
    update();
  }

  _callErrorSnackBar({required String title, required String message, bool failure = true}) {
    Get.snackbar(title, message,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(8),
        icon: !failure
            ? null
            : CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.close),
              ),
        backgroundColor: Colors.white,
        barBlur: 0,
        showProgressIndicator: !failure,
        snackStyle: SnackStyle.FLOATING);
  }

  String? validateBio(String? value) {}
}
