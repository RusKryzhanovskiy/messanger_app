class Validator {
  static bool isEmail(String text) {
    String pattern = "[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$"
        "%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)"
        "+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(text);
  }

  static bool isPassword(String text) {
    return text.length >= 8;
  }

  static bool isNotEmpty(String text) {
    return text.isNotEmpty;
  }

  static bool isAge(String text, {int minLengths, int maxLengths}) {
    String lengthsLimit;
    if (minLengths != null && maxLengths != null) {
      lengthsLimit = '{$minLengths,$maxLengths}';
    } else if (minLengths != null) {
      lengthsLimit = '{$minLengths,}';
    } else if (maxLengths != null) {
      lengthsLimit = '{1,$maxLengths}';
    } else {
      lengthsLimit = '+';
    }
    String pattern = "^\\\d$lengthsLimit\$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(text);
  }
}
