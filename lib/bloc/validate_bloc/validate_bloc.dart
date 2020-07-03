import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'validate_event.dart';
part 'validate_state.dart';

class ValidateBloc extends Bloc<ValidateEvent, ValidateState> {
  ValidateBloc() : super(InitialValidateState());

  @override
  Stream<ValidateState> mapEventToState(ValidateEvent event) async* {
    if (event is FirstnameField) {
      yield InitialValidateState();
      if (event.value.isEmpty) {
        yield FirstnameErrorField(errorText: 'Firstname can not empty.');
      }
    }

    if (event is LastnameField) {
      yield InitialValidateState();
      if (event.value.isEmpty) {
        yield LastnameErrorField(errorText: 'Lastname can not empty.');
      }
    }

    if (event is PhoneField) {
      yield InitialValidateState();
      if (event.value.isEmpty) {
        yield PhoneErrorField(errorText: 'Phone number can not empty.');
      } else if (event.value.length != 10) {
        yield PhoneErrorField(errorText: 'Phone number must be 10 chars.');
      }
    }

    if (event is EmailField) {
      yield InitialValidateState();
      if (event.value.isEmpty) {
        yield EmailErrorField(errorText: 'Email can not empty.');
      } else if (!event.value.contains("@")) {
        yield EmailErrorField(errorText: 'Not type email.');
      }
    }
  }
}
