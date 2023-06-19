import 'package:chatgpt_app/providers/models_provider.dart';
import 'package:chatgpt_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : DropdownButton(
                  dropdownColor: scaffoldBackgroundcolor,
                  iconEnabledColor: const Color.fromRGBO(255, 255, 255, 1),
                  items: List<DropdownMenuItem<String>>.generate(
                    models.length,
                    (index) => DropdownMenuItem(
                      value: snapshot.data![index].id,
                      child: Text(
                        snapshot.data![index].id,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  value: currentModel,
                  onChanged: (value) {
                    setState(() {
                      currentModel = value.toString();
                    });
                    modelsProvider.setCurrentModel(
                      value.toString(),
                    );
                  },
                );
        });
  }
}
