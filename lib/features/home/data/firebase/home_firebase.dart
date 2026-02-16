import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/features/auth/data/model/user_model.dart';
import 'package:tasky_app/features/home/data/model/task_model.dart';

abstract class HomeFirebase {
  static CollectionReference<TaskModel> get _getCollection {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection(UserModel.collection)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .doc(uid)
        .collection(TaskModel.collection)
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  static Future<Result<TaskModel>> addTask(TaskModel task) async {
    try {
      final doc = _getCollection.doc();
      task.id = doc.id;

      await doc.set(task);

      return Success<TaskModel>(task);
    } catch (e) {
      return ErrorState<TaskModel>(e.toString());
    }
  }

  static Future<Result<List<TaskModel>>> getTasks(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    try {
      final querySnapshot = await _getCollection
          .where("date", isEqualTo: normalizedDate.millisecondsSinceEpoch)
          .get();
      final docs = querySnapshot.docs;

      final listOfTask = docs.map<TaskModel>((doc) => doc.data()).toList();

      return Success<List<TaskModel>>(listOfTask);
    } catch (e) {
      return ErrorState<List<TaskModel>>(e.toString());
    }
  }

  static Future<Result<void>> toggleTaskStatus(TaskModel task) async {
    try {
      await _getCollection.doc(task.id).update({"isDone": !task.isDone!});
      return Success(null);
    } catch (e) {
      return ErrorState(e.toString());
    }
  }

  static Future<Result<void>> deleteTask(String taskId) async {
    try {
      await _getCollection.doc(taskId).delete();
      return Success(null);
    } catch (e) {
      return ErrorState(e.toString());
    }
  }

  static Future<Result<void>> updateTask(TaskModel task) async {
    try {
      await _getCollection.doc(task.id).update(task.toJson());
      return Success(null);
    } catch (e) {
      return ErrorState(e.toString());
    }
  }
}
