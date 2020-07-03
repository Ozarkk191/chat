part of 'validate_bloc.dart';

abstract class ValidateEvent {
  const ValidateEvent();
}

class FirstnameField extends ValidateEvent {
  final String value;
  FirstnameField({@required this.value});
}

class LastnameField extends ValidateEvent {
  final String value;
  LastnameField({@required this.value});
}

class PhoneField extends ValidateEvent {
  final String value;
  PhoneField({@required this.value});
}

class EmailField extends ValidateEvent {
  final String value;
  EmailField({@required this.value});
}
