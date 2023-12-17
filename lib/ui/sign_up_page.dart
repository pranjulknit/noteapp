import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/ui/widgets/custom_button.dart';
import 'package:noteapp/ui/widgets/custom_text_field.dart';

import '../cubit/auth /cubit/auth_cubit.dart';
import '../cubit/credential/cubit/credential_cubit.dart';
import '../models/user_model.dart';
import '../router/page_constant.dart';
import 'home_page.dart';
import 'widgets/common/common.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CredentialCubit, CredentialState>(
          listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          context.read<AuthCubit>().loggedIn(credentialState.user.uid!);
        }

        if (credentialState is CredentialFailure) {
          showSnackBarMessage(credentialState.errorMessage, context);
        }
      }, builder: (context, credentialState) {
        if (credentialState is CredentialLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
            if (authState is Authenticated) {
              return HomePage(uid: authState.uid);
            } else {
              return _bodyWidget();
            }
          });
        }
        return _bodyWidget();
      }),
    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Column(children: [
        const Center(
          child: Text(
            "Note App ",
            style: TextStyle(fontSize: 50),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        CustomTextField(
          hint: "Username",
          controller: _userNameController,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          hint: "email",
          controller: _emailController,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextField(
          hint: "password",
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          title: "Sign Up",
          onTap: _submitSignUp,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Already have an account "),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PageConst.signInPage, (route) => false);
              },
              child: Text(
                "Log in",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            )
          ],
        )
      ]),
    );
  }

  void _submitSignUp() {
    if (_userNameController.text.isEmpty) {
      showSnackBarMessage("Enter Username", context);

      return;
    }
    if (_emailController.text.isEmpty) {
      showSnackBarMessage("Enter Email", context);

      return;
    }

    if (_passwordController.text.isEmpty) {
      showSnackBarMessage("Enter Password", context);

      return;
    }

    context.read<CredentialCubit>().signUp(UserModel(
          username: _userNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ));
  }
}
