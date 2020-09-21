import 'package:flutter/material.dart';
import 'package:my_workout/models/exercise.dart';
import 'package:my_workout/models/workout.dart';
import 'package:my_workout/providers/exercise_provider.dart';
import 'package:provider/provider.dart';

class ExerciseManagementScreen extends StatefulWidget {
  static const String route = '/exercise-management';

  @override
  _ExerciseManagementScreenState createState() => _ExerciseManagementScreenState();
}

class _ExerciseManagementScreenState extends State<ExerciseManagementScreen> {
  Exercise _exercise = Exercise();

  final _imageFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _form = GlobalKey<FormState>();

  bool isInit = true;

  void _save() async {
    try {
      bool valid = _form.currentState.validate();

      if (valid) {
        _form.currentState.save();

        await Provider.of<ExerciseProvider>(context, listen: false).add(_exercise);
        Navigator.of(context).pop();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Falha ao salvar exercício'),
            content: Text('$e'),
          );
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final Map<String, Object> arguments = ModalRoute.of(context).settings.arguments;
      _exercise.workoutId = arguments['workoutId'];
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar novo exercício'),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/bg4.jpg'),
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
                    onSaved: (value) => _exercise.name = value,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.length < 3) {
                        return 'O nome deve conter pelo menos 3 caracteres';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_imageFocus),
                  ),
                  TextFormField(
                    onSaved: (value) => _exercise.imageUrl = value,
                    focusNode: _imageFocus,
                    decoration: InputDecoration(
                      labelText: 'Imagem URL',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (!value.startsWith('https://') && !value.startsWith('http://')) {
                        return 'Informe um endereço de imagem válido';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocus),
                  ),
                  TextFormField(
                    onSaved: (value) => _exercise.description = value,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                    ),
                    focusNode: _descriptionFocus,
                    maxLength: 200,
                    minLines: 3,
                    maxLines: 5,
                    buildCounter: (_, {currentLength, isFocused, maxLength}) => Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    validator: (value) {
                      if (value.length < 5) {
                        return 'A descrição deve conter pelo menos 5 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: RaisedButton(
                      onPressed: _save,
                      child: Text(
                        'Salvar',
                        style: TextStyle(color: Theme.of(context).textTheme.headline1.color),
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
