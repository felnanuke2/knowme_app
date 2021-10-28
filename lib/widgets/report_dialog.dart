import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';

class ReportDialog extends StatefulWidget {
  ReportDialog({Key? key}) : super(key: key);

  @override
  State<ReportDialog> createState() => _ReportDialogState();

  static show() {
    Get.dialog(ReportDialog());
  }
}

class _ReportDialogState extends State<ReportDialog> {
  final sessionController = Get.find<SesssionController>();

  final selectedMotivos = <String>[];

  bool sendReport = false;

  final motivos = <String>[
    'Nudez',
    'Violência',
    'Assédio',
    'Suicídio ou automultilação',
    'Notícia falsas',
    'Span',
    'Discurso de ódio',
    'Terrorismo',
    'Vendas de produtos ilícios',
    'Golpe ou fraude',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: Get.width,
        child: Dialog(
          insetPadding: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Column(
              children: [
                Text(
                  'Por que você está denunciando essa publicação?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600, fontSize: 22),
                ),
                SizedBox(
                  height: 24,
                ),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: [
                    ...List.generate(motivos.length, _buildMmotivoWidget),
                    InkWell(
                      onTap: _addNewMotivo,
                      child: Card(
                        color: Colors.grey.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Outros +',
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                if (!sendReport)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            onPressed: Get.back,
                            child: Text('Fechar')),
                        if (selectedMotivos.isNotEmpty)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(12),
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: _sendReport,
                              child: Text('Enviar Report'))
                      ],
                    ),
                  ),
                if (sendReport) LinearProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMmotivoWidget(int index) {
    return InkWell(
      onTap: () => _selectMotivo(index),
      child: Card(
        color: _getCardColor(index),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            motivos[index],
            style: GoogleFonts.openSans(
                color: _pickFontColor(index), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  _selectMotivo(int index) {
    final item = motivos[index];
    if (selectedMotivos.contains(item)) {
      selectedMotivos.remove(item);
    } else {
      selectedMotivos.add(item);
    }
    setState(() {});
  }

  Color _getCardColor(int index) {
    final item = motivos[index];
    if (selectedMotivos.contains(item)) {
      return Get.theme.primaryColor;
    } else {
      return Colors.grey.withOpacity(0.2);
    }
  }

  _pickFontColor(int index) {
    final item = motivos[index];
    if (selectedMotivos.contains(item)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  void _addNewMotivo() async {
    final motivoText = TextEditingController();
    final result = await Get.dialog(AlertDialog(
      content: Container(
        width: 360,
        height: 120,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Novo Motivo',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
                controller: motivoText,
                decoration: InputDecoration(labelText: 'Novo Motivo')),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(12),
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            onPressed: Get.back,
            child: Text('Fechar')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            onPressed: () => Get.back(result: motivoText.text),
            child: Text('Adicionar')),
      ],
    ));
    if (result != null) {
      motivos.add(result);
      selectedMotivos.add(result);
      setState(() {});
    }
  }

  void _sendReport() async {
    sendReport = true;
    setState(() {});
    await Future.delayed(Duration(seconds: 2));
    sendReport = false;

    Get.back();
    Get.rawSnackbar(
        messageText: Text(
          'A denúncia foi enviada com sucesso.',
          style: GoogleFonts.openSans(color: Colors.white),
        ),
        backgroundColor: Colors.green);
  }
}
