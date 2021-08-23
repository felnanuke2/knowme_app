import 'package:flutter/material.dart';

class CompletRegister extends StatelessWidget {
  const CompletRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(children: [
              Column(
                children: [
                  InkWell(
                    child: CircleAvatar(
                      child: Icon(
                        Icons.camera_alt,
                        size: 34,
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
                decoration:
                    InputDecoration(labelText: 'Nome Completo*', prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Nome do Perfil*',
                    helperText: 'Exempĺo: SeuNome21#',
                    prefixIcon: Icon(Icons.person_add_alt_1_outlined)),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Phone (Opcional)', prefixIcon: Icon(Icons.phone)),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Data de Nascimento (Opcional)',
                      prefixIcon: Icon(Icons.date_range))),
            ]),
          ),
        ),
      ),
    );
  }
}
