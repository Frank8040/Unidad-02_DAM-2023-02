import 'package:asistencia_app/models/User.dart';
import 'package:asistencia_app/utils/UrlApi.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'user_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  static UserApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return UserApi(dio);
  }

  @POST("/asis/login") //davidmpx@upeu.edu.pe //D123456
  Future<RespUserModel> login(@Body() UserModel usuario);
}
