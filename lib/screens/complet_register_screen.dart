import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/constants/constant_UF_and_citys.dart';
import 'package:knowme/controller/complet_profile_controller.dart';
import 'package:knowme/models/uf_model.dart';

class CompletRegister extends StatelessWidget {
  const CompletRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompletProfileController>(
      init: CompletProfileController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(children: [
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
                TextField(
                  controller: controller.nameTEC,
                  decoration:
                      InputDecoration(labelText: 'Nome Completo*', prefixIcon: Icon(Icons.person)),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: controller.profileNameTEC,
                  decoration: InputDecoration(
                      labelText: 'Nome do Perfil*',
                      helperText: 'Exemplo: SeuNome21#',
                      prefixIcon: Icon(Icons.person_add_alt_1_outlined)),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: controller.phoneTEC,
                  decoration:
                      InputDecoration(labelText: 'Fone (Opcional)', prefixIcon: Icon(Icons.phone)),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                    controller: controller.birthDayTEC,
                    readOnly: true,
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
                                    ? UfModel(sigla: 'null', nome: 'null', cidades: [])
                                    : BRAZILIAN_CITYS_JSON[index],
                                child: Text((BRAZILIAN_CITYS_JSON[index]?.sigla ?? 'Nenhum') +
                                    ' - ' +
                                    (BRAZILIAN_CITYS_JSON[index]?.nome ?? '')))),
                        child: IgnorePointer(
                          child: TextField(
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
                                  value: controller.selectedUfModel!.cidades[index],
                                  child: Text(controller.selectedUfModel!.cidades[index]))),
                          child: IgnorePointer(
                            child: TextField(
                                controller: controller.cityTEC,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelText: 'Cidade', prefixIcon: Icon(Icons.location_city))),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                    controller: controller.profileNameTEC,
                    decoration: InputDecoration(
                        labelText: 'Profissão (Opcional)', prefixIcon: Icon(Icons.work))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
