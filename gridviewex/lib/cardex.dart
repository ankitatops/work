import 'package:flutter/material.dart';

class Cardex extends StatefulWidget {
  const Cardex({super.key});

  @override
  State<Cardex> createState() => _CardexState();
}

class _CardexState extends State<Cardex> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          borderOnForeground: true,
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
        ),
      ),
    );
  }
}