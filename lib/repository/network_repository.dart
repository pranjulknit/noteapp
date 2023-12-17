import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:noteapp/models/user_model.dart';

import '../models/note_model.dart';

class ServerException implements Exception {
  final String errorMessage;

  ServerException(this.errorMessage);
}

class NetworkRepository {
  final http.Client httpClient = http.Client();

  String _endpoint(String endpoint) {
    return "http://10.0.2.2:5000/v1/$endpoint";
  }

  final Map<String, String> _header = {
    "Content-Type": "application/json; charset=utf-8"
  };

  Future<UserModel> signUp(UserModel user) async {
    final encodedParams = json.encode(user.toJson());

    final response = await httpClient.post(Uri.parse(_endpoint("user/signUp")),
        body: encodedParams, headers: _header);

    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(jsonDecode(response.body)['response']);

      return userModel;
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }

  Future<UserModel> signIn(UserModel user) async {
    try {
      final encodedParams = json.encode(user.toJson());
      print("encodedParams +$encodedParams");
      final response = await httpClient.post(
          Uri.parse(_endpoint("user/signIn")),
          body: encodedParams,
          headers: _header);

      print("responsecode ${response.statusCode}");
      if (response.statusCode == 200) {
        final userModel =
            UserModel.fromJson(jsonDecode(response.body)['response']);

        return userModel;
      } else {
        throw ServerException(json.decode(response.body)['response']);
      }
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<UserModel> myProfile(UserModel user) async {
    final response = await httpClient.get(
        Uri.parse(_endpoint("user/myProfile?uid=${user.uid}")),
        headers: _header);

    //print("resposne ${response.body}");
    if (response.statusCode == 200) {
      final userModel =
          UserModel.fromJson(json.decode(response.body)['response']);

      return userModel;
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }

  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final encodedParams = json.encode(user.toJson());
      print("encodedParams +$encodedParams");
      final response = await httpClient.put(
          Uri.parse(_endpoint("user/updateProfile")),
          body: encodedParams,
          headers: _header);

      print("responsecode ${response.statusCode}");
      if (response.statusCode == 200) {
        final userModel =
            UserModel.fromJson(jsonDecode(response.body)['response']);

        return userModel;
      } else {
        throw ServerException(json.decode(response.body)['response']);
      }
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<List<NoteModel>> getMyNotes(NoteModel notes) async {
    final response = await httpClient.get(
        Uri.parse(_endpoint("note/getMyNotes?uid=${notes.creatorId}")),
        headers: _header);

    //print("resposne ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> notes = json.decode(response.body)['response'];

      final notesData = notes.map((item) => NoteModel.fromJson(item)).toList();

      return notesData;
    } else {
      throw ServerException(json.decode(response.body)['response']);
    }
  }

  Future<void> addNote(NoteModel note) async {
    try {
      final encodedParams = json.encode(note.toJson());
      print("encodedParams +$encodedParams");
      final response = await httpClient.post(
          Uri.parse(_endpoint("note/addNote")),
          body: encodedParams,
          headers: _header);

      print("responsecode ${response.statusCode}");
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw ServerException(json.decode(response.body)['response']);
      }
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      final encodedParams = json.encode(note.toJson());
      print("encodedParams +$encodedParams");
      final response = await httpClient.put(
          Uri.parse(_endpoint("note/updateNote")),
          body: encodedParams,
          headers: _header);

      print("responsecode ${response.statusCode}");
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw ServerException(json.decode(response.body)['response']);
      }
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<void> deleteNote(NoteModel note) async {
    try {
      final encodedParams = json.encode(note.toJson());
      print("encodedParams +$encodedParams");
      final response = await httpClient.delete(
          Uri.parse(_endpoint("note/deleteNote")),
          body: encodedParams,
          headers: _header);

      print("responsecode ${response.statusCode}");
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw ServerException(json.decode(response.body)['response']);
      }
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }
}
