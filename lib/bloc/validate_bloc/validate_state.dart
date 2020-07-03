part of 'validate_bloc.dart';

abstract class ValidateState extends Equatable {
  const ValidateState();
}

class InitialValidateState extends ValidateState {
  @override
  List<Object> get props => null;
}

class FirstnameErrorField extends ValidateState {
  final String errorText;
  FirstnameErrorField({@required this.errorText});
  @override
  List<Object> get props => null;
}

class LastnameErrorField extends ValidateState {
  final String errorText;
  LastnameErrorField({@required this.errorText});
  @override
  List<Object> get props => null;
}

class PhoneErrorField extends ValidateState {
  final String errorText;
  PhoneErrorField({@required this.errorText});
  @override
  List<Object> get props => null;
}

class EmailErrorField extends ValidateState {
  final String errorText;
  EmailErrorField({@required this.errorText});
  @override
  List<Object> get props => null;
}
