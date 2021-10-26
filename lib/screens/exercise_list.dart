// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fitness_planner_app/models/exercise.dart';
import 'package:fitness_planner_app/screens/exercise_detail.dart';
import 'package:fitness_planner_app/screens/curr_location.dart';
import 'package:fitness_planner_app/utils/database_helper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Exercise> exerciseList;

  @override
  Widget build(BuildContext context) {
    if (exerciseList == null) {
      exerciseList = List<Exercise>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          LineIcons.dumbbell,
          color: Colors.white,
          size: 24.0,
        ),
        title: Text("Fitness Scheduler"),
        titleSpacing: 0,
        actions: [
          GestureDetector(
            onTap: () {
              navigateToMap();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.map),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: getExerciseListView(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: FloatingActionButton(
          heroTag: 'add',
          child: Icon(Icons.add),
          onPressed: () {
            debugPrint("HelloActionButton");
            navigateToDetail(Exercise('', 0, 0), "Add Exercise");
          },
        ),
      ),
    );
  }

  ListView getExerciseListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            color: Colors.blueGrey[100],
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: getWIcon(this.exerciseList[position].weight),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child:
                    Text(this.exerciseList[position].name, style: titleStyle),
              ),
              subtitle: Wrap(
                spacing: 5,
                children: [
                  Chip(
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.blueGrey,
                    label: Text('Sets: ${this.exerciseList[position].sets}',
                        style: TextStyle(color: Colors.white)),
                  ),
                  Chip(
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.blueGrey,
                    label: Text('Reps: ${this.exerciseList[position].reps}',
                        style: TextStyle(color: Colors.white)),
                  ),
                  Chip(
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.blueGrey,
                    label: Text('Weight: ${this.exerciseList[position].weight}',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              trailing: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.black,
                    size: 25.0,
                  ),
                ),
                onTap: () {
                  _delete(context, this.exerciseList[position]);
                },
              ),
              onTap: () {
                debugPrint("HelloExer");
                navigateToDetail(this.exerciseList[position], "Edit Exercise");
              },
            ));
      },
    );
  }

  void navigateToDetail(Exercise exercise, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ExerciseDetail(exercise, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CurrLoc()),
    );
  }

  Icon getWIcon(String weight) {
    if (weight == null) {
      return Icon(Icons.directions_run);
    } else {
      return Icon(Icons.fitness_center);
    }
  }

  void _delete(BuildContext context, Exercise exercise) async {
    int result = await databaseHelper.deleteExercise(exercise.id);
    if (result != 0) {
      _showSnackBar(context, "Exercise Completed");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar =
        SnackBar(content: Text(message), duration: Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Exercise>> exerciseListFuture =
          databaseHelper.getExerciseList();
      exerciseListFuture.then((exerciseList) {
        setState(() {
          this.exerciseList = exerciseList;
          this.count = exerciseList.length;
        });
      });
    });
  }
}
