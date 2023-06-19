import 'package:chatgpt_app/widgets/drop_down.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        backgroundColor: scaffoldBackgroundcolor,
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chosen Model: ',
                  style: TextStyle(color: Colors.white),
                ),
                Flexible(flex: 2, child: ModelsDropDownWidget())
              ],
            ),
          );
        });
  }
}
