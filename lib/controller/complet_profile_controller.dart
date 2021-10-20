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
    profileIsComplet =
        userAuthrepository.getCurrentUser?.profileComplet ?? false;
    if (!profileIsComplet) {
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..birthDay = dataModel?.birthDay == null
            ? null
            : formatDate(dataModel!.birthDay!, [dd, '/', mm, '/', yyyy]);
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..sex = dataModel?.gender;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..phoneNumber = dataModel?.phoneNumber;
    }
    _setFieldsFromUserModel();
  }

  _setFieldsFromUserModel() async {
    if (userAuthrepository.getCurrentUser != null) {
      nameTEC.text = userAuthrepository.getCurrentUser!.completName ?? '';
      phoneTEC.text = userAuthrepository.getCurrentUser!.phoneNumber ?? '';
      birthDayTEC.text = userAuthrepository.getCurrentUser!.birthDay ?? '';
      sexType = userAuthrepository.getCurrentUser!.sex;
      if (profileIsComplet) {
        final user = userAuthrepository.getCurrentUser!;
        profileNameTEC.text = user.profileName ?? '';
        phoneTEC.text = user.phoneNumber ?? '';
        birthDayTEC.text = user.birthDay ?? '';
        ufTEC.text = user.uf ?? '';
        bioTEC.text = user.bio ?? '';
        if (user.uf != null) {
          selectedUfModel = BRAZILIAN_CITYS_JSON
              .firstWhere((element) => element?.sigla.toUpperCase() == user.uf);
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

  var phoneMask = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

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
    var image = await ImagePickerBottomSheet.showImagePickerBottomSheet(
        Get.context!,
        circular: true);
    if (image == null) return;
    imageProfile = image;

    update();
  }

  onPickerDate() async {
    var pickedDate = await showDatePicker(
        initialDatePickerMode: DatePickerMode.year,
        initialEntryMode: DatePickerEntryMode.calendar,
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
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..birthDay = birthDayTEC.text;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..city = cityTEC.text;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..uf = ufTEC.text;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..uf = ufTEC.text;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..completName = nameTEC.text;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..bio = '';

      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..phoneNumber = phoneTEC.text;

      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..profileName = profileNameTEC.text;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..profileComplet = true;
      userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
        ?..sex = sexType;

      try {
        if (imageProfile != null) {
          final imagURl = await repository.upLoadImage(
              imageByte: imageProfile!,
              userID: userAuthrepository.getCurrentUser!.id!);
          userAuthrepository.setCurrentUser = userAuthrepository.getCurrentUser
            ?..profileImage = imagURl;
        }

        final user =
            await repository.createUser(userAuthrepository.getCurrentUser!);
        userAuthrepository.setCurrentUser = user;
        await Future.delayed(Duration(seconds: 2));
        if (!userAuthrepository.currentUserdataCompleter.isCompleted) {
          userAuthrepository.currentUserdataCompleter.complete();
        }

        Get.offAll(() => MainScreen());
      } on RequestError catch (e) {
        print(e.message);
        _callErrorSnackBar(
            title: 'Erro ao Completar o Perfil', message: e.message ?? '');
      }
    } else {
      try {
        final responseUser = await repository.updateUser(
            userAuthrepository.getCurrentUser!.id!,
            birthDay: birthDayTEC.text,
            city: cityTEC.text,
            completName: nameTEC.text,
            phoneNumber: phoneTEC.text,
            profileName: profileNameTEC.text,
            sex: sexType.toString(),
            uf: ufTEC.text,
            bio: bioTEC.text);
        userAuthrepository.setCurrentUser = responseUser..profileComplet = true;
        Get.back(result: responseUser);
      } on RequestError catch (e) {
        _callErrorSnackBar(
            title: 'Erro ao Completar o Perfil', message: e.message ?? '');
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
      if (value.length < phoneMask.getMask()!.length)
        return 'Telefone Inválido';
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

  _callErrorSnackBar(
      {required String title, required String message, bool failure = true}) {
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
