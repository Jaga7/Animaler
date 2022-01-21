import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  // form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {

    ModelUser user = Provider.of<ModelUser>(context);

    return StreamBuilder<ModelUserData>(
      stream: DatabaseService(uid: user.uid).modelUserData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          ModelUserData modelUserData = snapshot.data as ModelUserData;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your brew settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: modelUserData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  value: _currentSugars ?? modelUserData.sugars,
                  decoration: textInputDecoration,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentSugars = val as String ),
                ),
                SizedBox(height: 10.0),
                Slider(
                  value: (_currentStrength ?? modelUserData.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? modelUserData.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? modelUserData.strength],
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStrength = val.round()),
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      await DatabaseService(uid: user.uid).updateModelUserData(
                        _currentSugars ?? snapshot.data!.sugars, 
                        _currentName ?? snapshot.data!.name, 
                        _currentStrength ?? snapshot.data!.strength
                      );
                      Navigator.pop(context);
                    }
                  }
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}