import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yandex_mapkit_example/add_bio_screen.dart';
import 'package:yandex_mapkit_example/store.dart';

class AddGraveScreen extends StatefulWidget {
  const AddGraveScreen({Key? key}) : super(key: key);

  @override
  _AddGraveScreenState createState() => _AddGraveScreenState();
}

class _AddGraveScreenState extends State<AddGraveScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _dob = '';
  String _dod = '';
  File? _imageFile;
  bool _isImageLoading = false;

  Future<void> _saveGrave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isImageLoading = true;
    });

    // Simulate uploading image to a server with a delay of 2 seconds
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isImageLoading = false;
    });

    Store.grave.name = _name;
    Store.grave.dob = _dob;
    Store.grave.dod = _dod;
    Store.grave.file = _imageFile?.path;

    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AddBioScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить памятный объект'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    height: 200,
                  )
                else
                  Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  ),
                SizedBox(height: 10),
                if (_isImageLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: () {
                      // Simulate selecting an image from the gallery with a delay of 1 second
                      pickImage();
                    },
                    icon: Icon(Icons.photo),
                    label: Text('Выбрать фото'),
                  ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Пожалуйста, введите имя';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'День рождения',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Пожалуйста, введите дату рождения';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _dob = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'День смерти',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Пожалуйста, введите дату смерти';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _dod = value!;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.save();
                            _saveGrave();
                          },
                          child: Text('Далее (1/3)'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (result != null) {
        _imageFile = File(result.path);
      }
    });
  }
}
