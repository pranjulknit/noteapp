import 'package:flutter/material.dart';
import 'package:noteapp/models/note_model.dart';
import 'package:noteapp/router/page_constant.dart';
import 'package:noteapp/ui/add_note_page.dart';
import 'package:noteapp/ui/profile_page.dart';
import 'package:noteapp/ui/sign_up_page.dart';
import 'package:noteapp/ui/update_note_page.dart';

import '../ui/sign_in_page.dart';

class onGenreateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.signUpPage:
        {
          return materialPagebuilder(widget: const SignUpPage());
        }
      case PageConst.signInPage:
        {
          return materialPagebuilder(widget: const SignInPage());
        }
      case PageConst.profilePage:
        {
          if (args is String) {
            return materialPagebuilder(widget: ProfilePage(uid: args));
          } else {
            return materialPagebuilder(widget: const ErrorPage());
          }
        }
      case PageConst.addNotePage:
        {
          if (args is String) {
            return materialPagebuilder(
                widget: AddNotePage(
              uid: args,
            ));
          } else {
            return materialPagebuilder(widget: ErrorPage());
          }
        }

      case PageConst.updateNotePage:
        {
          if (args is NoteModel) {
            return materialPagebuilder(
                widget: UpdateNotePage(
              note: args,
            ));
          } else {
            return materialPagebuilder(widget: ErrorPage());
          }
        }

      default:
        return materialPagebuilder(widget: const ErrorPage());
    }
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("error")),
        body: const Center(
          child: Text("error"),
        ));
  }
}

MaterialPageRoute materialPagebuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
