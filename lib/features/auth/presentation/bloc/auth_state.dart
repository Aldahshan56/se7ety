class AuthState {}

class AuthInitial extends AuthState {}

// login
class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final String userType;
  LoginSuccessState({required this.userType});
}

// register
class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {}

// doctor register
class DoctorRegistrationLoadingState extends AuthState {}

class DoctorRegistrationSuccessState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({required this.message});
}