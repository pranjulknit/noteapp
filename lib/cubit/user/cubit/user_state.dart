part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded(this.user);
  List<Object> get props => [user];
}

final class UserFailure extends UserState {}
