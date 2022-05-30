import 'package:formz/formz.dart';

enum EmailAddressValidationError { empty }

class EmailAddress extends FormzInput<String, EmailAddressValidationError> {
  const EmailAddress.pure() : super.pure('');
  const EmailAddress.dirty([String value = '']) : super.dirty(value);

  @override
  EmailAddressValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : EmailAddressValidationError.empty;
  }
}
