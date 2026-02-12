import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/core/networking/result.dart';
import 'package:tasky_app/features/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthFunctions {
  static CollectionReference<UserModel> get _getCollection {
    return FirebaseFirestore.instance
        .collection(UserModel.collection)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static Future<void> addUser(UserModel user) async {
    await _getCollection.doc(user.id).set(user);
  }

  static Future<Result<String>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success<String>(user.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ErrorState<String>("User Not Found please Register now");
      } else {
        return ErrorState<String>("Wrong Password");
      }
    } catch (e) {
      return ErrorState<String>("Error $e");
    }
  }

  //

  static Future<Result<UserModel>> registerUser({
    required UserModel user,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          );
      user.id = credential.user?.uid;
      await AuthFunctions.addUser(user);

      return Success<UserModel>(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ErrorState<UserModel>("The Password is too week");
      } else if (e.code == 'email-already-in-use') {
        return ErrorState<UserModel>("The email is already Exist");
      } else if (e.code == 'invalid-email') {
        return ErrorState<UserModel>("Invalid email");
      } else {
        return ErrorState<UserModel>(e.message ?? "SomeThing Error");
      }
    } catch (e) {
      return ErrorState<UserModel>("Error: ${e.toString()}");
    }
  }
}
