import 'package:flutter/material.dart';
import 'package:my_workout/providers/exercise_provider.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  ExerciseCard(this.id, this.name, this.description, this.imageUrl);

  void _delete(BuildContext context) async {
    await Provider.of<ExerciseProvider>(context, listen: false).delete(id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle2.color,
          ),
        ),
        leading: FadeInImage(
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/images/halter.png'),
          image: NetworkImage(
            imageUrl,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () => _delete(context),
        ),
      ),
    );
  }
}
