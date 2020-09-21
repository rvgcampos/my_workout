import 'package:flutter/material.dart';
import 'package:my_workout/models/workout.dart';
import 'package:my_workout/providers/workout_provider.dart';
import 'package:provider/provider.dart';

class WorkoutManagementScreen extends StatefulWidget {
  static const String route = '/workout-magement';
  @override
  _WorkoutManagementScreenState createState() => _WorkoutManagementScreenState();
}

class _WorkoutManagementScreenState extends State<WorkoutManagementScreen> {
  Workout _workout = Workout();
  final _imageFocus = FocusNode();
  final _dropDownFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _dropDownValid = true;
  int _dropDownValue;
  bool isInit = true;

  final List<Map<String, Object>> _dropDownOptions = [
    {'id': 1, 'name': 'Segunda-Feira'},
    {'id': 2, 'name': 'Terça-Feira'},
    {'id': 3, 'name': 'Quarta-Feira'},
    {'id': 4, 'name': 'Quinta-Feira'},
    {'id': 5, 'name': 'Sexta-Feira'},
    {'id': 6, 'name': 'Sábado'},
    {'id': 7, 'name': 'Domingo'},
  ];

  void _save() async {
    try {
      if (_dropDownValue != null && _dropDownValue > 0) {
        setState(() {
          _dropDownValid = true;
        });
      } else {
        setState(() {
          _dropDownValid = false;
        });
      }

      bool valid = _form.currentState.validate();
      if (valid && _dropDownValid) {
        print('Formulário válido');
        _form.currentState.save();
        _workout.weekDay = _dropDownValue;

        if (_workout.id != null) {
          await Provider.of<WorkoutProvider>(context, listen: false).update(_workout);
        } else {
          await Provider.of<WorkoutProvider>(context, listen: false).add(_workout);
        }
        Navigator.of(context).pop();
      }
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('$e'), 
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
      if (arguments['id'] != null) {
        _workout = Provider.of<WorkoutProvider>(context, listen: false).getById(arguments['id']);
        _dropDownValue = _workout.weekDay;
      }
    }
    isInit = false;
  }

  void _delete() async {
    Navigator.of(context).pop();
    await Provider.of<WorkoutProvider>(context, listen: false).delete(_workout.id);
    Navigator.of(context).pop();
  }

  void _showConfirmationModal() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Você tem certeza?'),
          content: Text('Esta ação não poderá ser desfeita!'),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            FlatButton(
              onPressed: _delete,
              child: Text('Sim, continuar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(arguments['title']),
        actions: _workout.id != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _showConfirmationModal,
                )
              ]
            : [],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/bg2.jpg'),
              fit: BoxFit.cover,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: _workout.name,
                    onSaved: (value) => _workout.name = value,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_imageFocus),
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 3) {
                        return 'O nome deve conter pelo menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _workout.imageUrl,
                    onSaved: (value) => _workout.imageUrl = value,
                    focusNode: _imageFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_dropDownFocus),
                    decoration: InputDecoration(labelText: 'Imagem URL'),
                    validator: (value) {
                      if (!value.startsWith('http://') && !value.startsWith('https://')) {
                        return 'Endereço de imagem inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 0.5,
                  ),
                  DropdownButtonHideUnderline(
                    child: Container(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      padding: EdgeInsets.all(15),
                      child: DropdownButton(
                        value: _dropDownValue,
                        focusNode: _dropDownFocus,
                        items: _dropDownOptions
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e['name']),
                                value: e['id'],
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _dropDownValue = value;
                          });
                        },
                        hint: Text(
                          'Dia da semana',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color,
                          ),
                        ),
                        icon: Icon(Icons.calendar_today),
                        isExpanded: true,
                        iconEnabledColor: Theme.of(context).accentColor,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                          color: Theme.of(context).textTheme.headline1.color,
                        ),
                        dropdownColor: Color.fromRGBO(48, 56, 62, 0.9),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _dropDownValid ? '' : 'Seleciona um dia da semana',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: RaisedButton(
                      onPressed: _save,
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
