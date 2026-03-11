import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/src/services/api_services.dart';

class UserManager {
  static final Logger log = Logger('UserManager');

  ApiServices get _api => GetIt.instance.get<ApiServices>();

  ///使用邮箱登录
  Future<void> loginByEmail({required String email, required String password}) async {}
}
