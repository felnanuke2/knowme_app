import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AnswersDialog extends StatelessWidget {
  const AnswersDialog({
    Key? key,
    required this.answers,
  }) : super(key: key);
  final Map answers;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 28,
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final key = answers.keys.toList()[index];
                var answer = answers[key];
                if (answer is List) {
                  final buffer = StringBuffer();
                  answer.forEach((value) {
                    if (buffer.isEmpty) {
                      buffer.write(value);
                    } else {
                      buffer.write(', ' + value);
                    }
                  });
                  answer = buffer.toString();
                }

                return Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          isThreeLine: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: Get.theme.primaryColor)),
                          title: Text(key),
                          subtitle: Text('\n' + answer),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  static showDialog(Map answers) {
    Get.dialog(AnswersDialog(answers: answers));
  }
}
