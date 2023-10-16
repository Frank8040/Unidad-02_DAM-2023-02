part of 'user_api.dart';

class _UserApi implements UserApi {
  _UserApi(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://172.22.5.16:8080';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<RespUserModel> login(UserModel usuario) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    data.addAll(usuario.toJson());
    final result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<RespUserModel>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
            .compose(
              _dio.options,
              '/asis/login',
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RespUserModel.fromJson(result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
