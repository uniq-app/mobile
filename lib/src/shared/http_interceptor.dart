import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_interceptor/interceptor_contract.dart';
import 'package:uniq/src/services/auth_api_provider.dart';

class LoggingInterceptor implements InterceptorContract {
  final authApiProvider = AuthApiProvider();
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    String token = await authApiProvider.getToken();
    data.headers['Authorization'] = "Bearer $token";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print("${data.url}: ${data.statusCode}");
    return data;
  }
}
