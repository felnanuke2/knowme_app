import 'package:flutter/material.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart' as instance;

import 'package:knowme/constants/constant_UF_and_citys.dart';
import 'package:knowme/controller/complet_profile_controller.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/uf_model.dart';
import 'package:knowme/models/user_model.dart';

class CompletRegisterScreen extends StatelessWidget {
  UserModel? userModel;

  ThirdPartUserDataModel? dataModel;
  CompletRegisterScreen({
    Key? key,
    this.userModel,
    this.dataModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompletProfileController>(
      init: CompletProfileController(
        userAuthrepository: instance.Get.find<UserAuthInterface>(),
        repository: instance.Get.find<DbRepositoryInterface>(),
        dataModel: dataModel,
      ),
      builder: (controller) => Scaffold(
        appBar: _buildAppBar(controller),
        body: Stack(
          children: [
            _buildForm(controller),
            Obx(() => Visibility(
                  visible: controller.sendFormLoadingState.value,
                  child: Positioned.fill(
                      child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Center(child: LinearProgressIndicator()),
                  )),
                )),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(CompletProfileController controller) {
    return AppBar(
      title: Text(
          controller.profileIsComplet ? 'Editar Perfil' : 'Finalizar Perfil'),
      leading: controller.profileIsComplet
          ? IconButton(onPressed: Get.back, icon: Icon(Icons.close))
          : null,
      actions: [
        ElevatedButton.icon(
          onPressed: controller.onCompletProfile,
          label: Text('Concluir'),
          icon: Icon(Icons.check),
          style: ElevatedButton.styleFrom(
            elevation: 0,
          ),
        )
      ],
    );
  }

  SafeArea _buildForm(CompletProfileController controller) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(children: [
              if (!controller.profileIsComplet)
                Column(
                  children: [
                    InkWell(
                      onTap: controller.onImagePfofilePressed,
                      child: CircleAvatar(
                        child: controller.imageProfile == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 34,
                              )
                            : Container(
                                width: 140,
                                height: 140,
                                child: ClipOval(
                                  child: Image.memory(
                                    controller.imageProfile!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        radius: 70,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Foto de perfil')
                  ],
                ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                validator: controller.validateUserName,
                controller: controller.nameTEC,
                decoration: InputDecoration(
                    labelText: 'Nome Completo*',
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: controller.validateProfileName,
                controller: controller.profileNameTEC,
                decoration: InputDecoration(
                    labelText: 'Nome do Perfil*',
                    helperText: 'Exemplo: SeuNome211',
                    prefixIcon: Icon(Icons.person_add_alt_1_outlined)),
              ),
              if (controller.profileIsComplet)
                SizedBox(
                  height: 15,
                ),
              if (controller.profileIsComplet)
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: controller.validateBio,
                  controller: controller.bioTEC,
                  minLines: 2,
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Bio (Opcional)',
                      prefixIcon: Icon(Icons.description)),
                ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: controller.validatePhone,
                inputFormatters: [controller.phoneMask],
                controller: controller.phoneTEC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Fone (Opcional)',
                    helperText: 'Ex: (00) 90000-0000',
                    prefixIcon: Icon(Icons.phone)),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  validator: controller.validateDate,
                  controller: controller.birthDayTEC,
                  readOnly: true,
                  onTap: controller.onPickerDate,
                  decoration: InputDecoration(
                      labelText: 'Data de Nascimento (Opcional)',
                      prefixIcon: Icon(Icons.date_range))),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: PopupMenuButton<UfModel?>(
                      initialValue: controller.selectedUfModel,
                      onSelected: controller.onselectUF,
                      itemBuilder: (BuildContext context) => List.generate(
                          BRAZILIAN_CITYS_JSON.length,
                          (index) => PopupMenuItem<UfModel?>(
                              value: BRAZILIAN_CITYS_JSON[index] == null
                                  ? UfModel(
                                      sigla: 'null', nome: 'null', cidades: [])
                                  : BRAZILIAN_CITYS_JSON[index],
                              child: Text((BRAZILIAN_CITYS_JSON[index]?.sigla ??
                                      'Nenhum') +
                                  ' - ' +
                                  (BRAZILIAN_CITYS_JSON[index]?.nome ?? '')))),
                      child: IgnorePointer(
                        child: TextFormField(
                            validator: controller.validateUf,
                            controller: controller.ufTEC,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'UF(Opcional)',
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  if (controller.selectedUfModel != null)
                    Expanded(
                      flex: 2,
                      child: PopupMenuButton<String>(
                        onSelected: controller.onCitySelected,
                        itemBuilder: (BuildContext context) => List.generate(
                            controller.selectedUfModel!.cidades.length,
                            (index) => PopupMenuItem(
                                value:
                                    controller.selectedUfModel!.cidades[index],
                                child: Text(controller
                                    .selectedUfModel!.cidades[index]))),
                        child: IgnorePointer(
                          child: TextFormField(
                              validator: controller.validateCity,
                              controller: controller.cityTEC,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: 'Cidade',
                                  prefixIcon: Icon(Icons.location_city))),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Gênero:',
                  style: router.Get.textTheme.headline6!.copyWith(fontSize: 18),
                ),
              ),
              RadioListTile(
                value: Sex.FEMALE,
                title: Text('Feminino'),
                groupValue: controller.sexType,
                onChanged: controller.changeSexType,
              ),
              RadioListTile(
                value: Sex.MALE,
                title: Text('Masculino'),
                groupValue: controller.sexType,
                onChanged: controller.changeSexType,
              ),
              RadioListTile(
                value: Sex.NONE,
                title: Text('Outros'),
                groupValue: controller.sexType,
                onChanged: controller.changeSexType,
              ),
              Obx(() => Text(
                    controller.sextypeError.value,
                    style: TextStyle(color: Colors.red),
                  )),
              SizedBox(
                height: 40,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
