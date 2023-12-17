part of 'credential_cubit.dart';

sealed class CredentialState extends Equatable {
  const CredentialState();

  @override
  List<Object> get props => [];
}

final class CredentialInitial extends CredentialState {}

final class CredentialLoading extends CredentialState {}

final class CredentialSuccess extends CredentialState {
  final UserModel user;

  CredentialSuccess(this.user);
}

final class CredentialFailure extends CredentialState {
  final String errorMessage;

  CredentialFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
