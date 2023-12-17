import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/cubit/user/cubit/user_cubit.dart';
import 'package:noteapp/ui/widgets/common/common.dart';
import 'package:noteapp/ui/widgets/custom_button.dart';
import 'package:noteapp/ui/widgets/custom_text_field.dart';

import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    print("uid-profile ${widget.uid}");
    context.read<UserCubit>().myProfile(UserModel(uid: widget.uid));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Update Profile"),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserLoaded) {
            _updateDetails(userState.user);
            return Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("username"),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      hint: "username",
                      controller: _usernameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Email"),
                    const SizedBox(
                      height: 5,
                    ),
                    AbsorbPointer(
                      child: CustomTextField(
                        hint: "Email",
                        controller: _emailController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(title: "Update Profile", onTap: _updateProfile)
                  ]),
            );
          }
          print("userState -> $userState");
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _updateProfile() {
    if (_usernameController.text.isEmpty) {
      showSnackBarMessage("Enter Username", context);
      return;
    }

    context
        .read<UserCubit>()
        .updateProfile(
            UserModel(uid: widget.uid, username: _usernameController.text))
        .then((value) {
      showSnackBarMessage("Profile Updated Successfully", context);
    });
  }

  void _updateDetails(UserModel user) {
    _emailController.value = TextEditingValue(text: user.email!);
    _usernameController.value = TextEditingValue(text: user.username!);
  }
}
