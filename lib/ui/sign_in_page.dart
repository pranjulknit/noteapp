import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/cubit/auth%20/cubit/auth_cubit.dart';
import 'package:noteapp/cubit/credential/cubit/credential_cubit.dart';
import 'package:noteapp/models/user_model.dart';
import 'package:noteapp/router/page_constant.dart';
import 'package:noteapp/ui/home_page.dart';
import 'package:noteapp/ui/widgets/common/common.dart';
import 'package:noteapp/ui/widgets/custom_button.dart';
import 'package:noteapp/ui/widgets/custom_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
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
      }, builder: (context, CredentialState) {
        if (CredentialState is CredentialLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (CredentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
            if (authState is Authenticated) {
              print("authstate - uid ${authState.uid}");
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
        title: const Text("Sign In"),
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
        CustomButton(title: "Login", onTap: _submitSignIn),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Don't have an account "),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PageConst.signUpPage, (route) => false);
              },
              child: Text(
                "Sign Up",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            )
          ],
        )
      ]),
    );
  }

  void _submitSignIn() {
    if (_emailController.text.isEmpty) {
      showSnackBarMessage("Enter Email", context);

      return;
    }

    if (_passwordController.text.isEmpty) {
      showSnackBarMessage("Enter Password", context);

      return;
    }

    context.read<CredentialCubit>().signIn(UserModel(
        email: _emailController.text, password: _passwordController.text));
  }
}
