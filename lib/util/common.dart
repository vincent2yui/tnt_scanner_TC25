import 'package:tnt_scanner/util/constant.dart';

String removeSuffix(String code) {
  return code.replaceAll(new RegExp(kSuffix), ''); //Remove ',' suffix
}
