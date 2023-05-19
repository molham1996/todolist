// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_list_app/services/slider_service.dart';
import 'package:todo_list_app/utils/snackbar_helper.dart';

class AddSliderPage extends StatefulWidget {
  final Map? slider;
  const AddSliderPage({super.key, this.slider});

  @override
  State<AddSliderPage> createState() => _AddSliderPageState();
}

class _AddSliderPageState extends State<AddSliderPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtextController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController imageDataController = TextEditingController();

  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final slider = widget.slider;
    if (slider != null) {
      isEdit = true;
      final title = slider['title'];
      final subtext = slider['subtext'];
      titleController.text = title['en'];
      subtextController.text = subtext['en'];
      urlController.text = slider['url'];
      imageController.text = slider['image'];
      imageDataController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Slider' : 'Add Slider')),
      body: ListView(padding: EdgeInsets.all(20), children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: 'Title'),
        ),
        TextField(
          controller: subtextController,
          decoration: InputDecoration(hintText: 'Subtext'),
          keyboardType: TextInputType.multiline,
          maxLines: 8,
          minLines: 5,
        ),
        TextField(
          controller: urlController,
          decoration: InputDecoration(hintText: 'URL'),
        ),
        TextField(
          controller: imageController,
          decoration: InputDecoration(hintText: 'Image'),
        ),
      
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            )),
      ]),
    );
  }

  Future<void> submitData() async {
    final isSuccess = await SliderService.addSlider(body);

    if (isSuccess) {
      titleController.text = '';
      subtextController.text = '';
      imageController.text = '';
      urlController.text = '';
      imageDataController.text = '';
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Future<void> updateData() async {
    final slider = widget.slider;
    if (slider == null) {
      showErrorMessage(context,
          message: 'You cannot call update without slider data');
      return;
    }
    final id = slider['id'];
   
    final isSuccess = await SliderService.updateSlider(id, body);

    if (isSuccess) {
      showSuccessMessage(context, message: 'Update Success');
    } else {
      showErrorMessage(context, message: 'Update Failed');
    }
  }

  Map get body {
    final title = titleController.text;
    final subtext = subtextController.text;
    return {
      "id": "",
      "title": {"en": title, "ar": "", "tr": ""},
      "subtext": {"en": subtext, "ar": "", "tr": ""},
      "url": urlController.text,
      "image": imageController.text,
      "imageData": ""
    };
  }
}
