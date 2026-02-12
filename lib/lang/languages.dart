import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override

  Map<String, Map<String, String>> get keys => {
    'en_US': {
        'logged_in': 'logged in as @name with email @email',
    },
  };

}