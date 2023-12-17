import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/shared_pref.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final sharedPref = SharedPref();

  Future<void> appStarted() async {
    final uid = await sharedPref.getUID();
    print("uid ${uid}");
    try {
      if (uid != null) {
        emit(Authenticated(uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn(String uid) async {
    sharedPref.setUID(uid);
    emit(Authenticated(uid));
  }

  Future<void> loggedOut() async {
    sharedPref.setUID("");
    emit(UnAuthenticated());
  }
}
