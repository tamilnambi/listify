

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'login_provider.dart';

class ProviderList {
  static List<SingleChildWidget> getProviders() {
    return <SingleChildWidget>[
      ChangeNotifierProvider.value(value: LoginProvider()),
    ];
  }
}
