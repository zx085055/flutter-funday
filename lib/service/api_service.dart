import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_funday/constants.dart';
import 'package:flutter_funday/service/http_interceptor.dart';
import 'package:flutter_funday/service/model/audio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

class APIRouter {
  static const openAPI = '/open-api';
  static const audio = '/Media/Audio';
}

class APIService {
  APIService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.travel.taipei',
        connectTimeout: kHttpRequestTimeout,
        sendTimeout: kHttpRequestTimeout,
        receiveTimeout: kHttpRequestTimeout,
        contentType: 'application/json; charset=utf-8',
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          try {
            await _interceptorRequest(options, handler);
          } on Object catch (error) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                error: error,
              ),
              true,
            );
          }
        },
      ),
    );

    _client = _IRestClient(_dio);
  }

  late Dio _dio;
  late _IRestClient _client;

  // ignore: library_private_types_in_public_api
  _IRestClient get client => _client;

  Future<void> _interceptorRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['accept'] = 'application/json';

    handler.next(options);
  }

  Future<void> dioDownload(
    String url,
    File file,
    Function(int) onReceiveProgress,
    Function(File) onComplete,
    Function(Object) onError,
  ) async {
    try {
      var option = BaseOptions(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      );

      option.connectTimeout = kHttpPingDownload;
      option.sendTimeout = kHttpPingDownload;
      option.receiveTimeout = kHttpPingDownload;

      var dio = Dio(option);
      dio.interceptors.add(HttpInterceptor());

      var response = await dio.get<List<int>>(
        url,
        onReceiveProgress: (received, total) {
          var percent = int.parse(((received / total) * 100).toStringAsFixed(0));
          onReceiveProgress(percent);
        },
      );
      file.writeAsBytesSync(response.data!);
      onComplete(file);
    } on Object catch (error) {
      onError(error);
    }
  }
}

@RestApi()
abstract class _IRestClient {
  factory _IRestClient(Dio dio) = __IRestClient;

  /// 語音導覽
  // + [GET] /zh-tw/Media/Audio
  @GET('${APIRouter.openAPI}/{lang}${APIRouter.audio}')
  @NoBody()
  Future<Audio> audio({
    @Path('lang') required String lang,
    @Query('page') required int page,
  });
}
