import 'package:base_bloc_3/import.dart';

List<FilteringTextInputFormatter> getFormatValidTextFieldBlockSpace() {
  return [
    FilteringTextInputFormatter.deny(
      RegExp(r'\s'),
    ),
  ];
}

List<FilteringTextInputFormatter> getFormatValidTextFieldOnlyAlphabet() {
  return [
    FilteringTextInputFormatter.allow(
      //only allow alphabet vietnamese
      RegExp(
        '[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ ]',
      ),
    ),
  ];
}

/// Response from API is not defined static type, you must claim BE team to define the type
/// Or you can temporary use this function to continue the work
/// Ex: Value of field "age" can be 18.0 or 18 or "18", so you can use this function to get the integer 18
int? getIntegerFromDynamic(dynamic value) {
  if (value is double) {
    return value.toInt();
  } else if (value is int) {
    return value;
  } else if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
