import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/profile_controller.dart';
import 'package:get/route_manager.dart';

class EditProfileInfosScreen extends StatelessWidget {
  const EditProfileInfosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: Get.back, icon: Icon(Icons.close)),
          title: Text('Editar Perfil'),
          actions: [
            IconButton(
                onPressed: controller.updateUserProfile,
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ))
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome do perfil'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bio'),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Informações Pessoais',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Data de nascimento'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Uf'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'City'),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
