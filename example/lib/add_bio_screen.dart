import 'package:flutter/material.dart';
import 'package:yandex_mapkit_example/examples/suggest_page.dart';
import 'package:yandex_mapkit_example/store.dart';

class AddBioScreen extends StatefulWidget {
  @override
  _AddBioScreenState createState() => _AddBioScreenState();
}

class _AddBioScreenState extends State<AddBioScreen> {
  String _bioText = '';

  void _onBioTextChanged(String text) {
    setState(() {
      _bioText = text;
    });
  }

  void _onSubmit() {
    // Handle submit action here
    print('Bio text submitted: $_bioText');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bio Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Введите описание'),
            SizedBox(height: 8.0),
            TextField(
              maxLines: null,
              onChanged: _onBioTextChanged,
            ),
            SizedBox(height: 16.0),
            Container(
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  Store.grave?.bio = _bioText;
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => SuggestionsPage(),
                    ),
                  );
                },
                child: Text('Далее (2/3)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
