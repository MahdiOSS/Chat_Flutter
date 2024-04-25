import 'package:dio/dio.dart';

const CHAT_TOKEN =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNWQ5NWI1NDE0ODE3ZmUyYmExZmRlOWE2MDA2M2EzZjI3OWJjNTNiNTRiN2MxMTMzZDBjZWY4MTIwNjcwMTFiYWI0ZDczZjhiN2U2Y2M3MjUiLCJpYXQiOjE3MTI0MDIzNzUuMTc4NDMxLCJuYmYiOjE3MTI0MDIzNzUuMTc4NDMzLCJleHAiOjE3NDM5MzgzNzUuMTc1MTc3LCJzdWIiOiI4NCIsInNjb3BlcyI6W119.M1n3TctyUaWOgCUl2iBqpcXZTxnxFYmPVrjVvQQ5PC3gMAP8Dqir-l9q4txZ8nrD6OSB-abxL1C9MTJYapYzQu6ogy76swdXeSZDrPgTAbo3WxNq-MZ9y-qCGDdJFJQez-cqcsJY6Iq1Xlw7nVbjMJd0aA4jMtrVBoy10CqPCDjdUl__rtvdxg1PXIhEGlaf0PH71Mm_are3bN4oGZIJhW9-0G8ESGkPfRbCMW633b3D5zLwe0XKbUutVqawQeWMMuzNlAeowfQQkbXZ_66NMUVbMajnUnkoaKL4YHg5g6yuvcO0c7UGNKreu0jAXm8SlAqXfy2kt6aWmxF7syjAf3YVq2ercHFDkmcVTFqS8IEvvImmRbnFOM2JxRY2BQreagdDPof1S7o1Wh2SfFFmUDbLeJrSpzSxeyQXU8apFigSgjgSjyX9YEOhM5Oh2B2KxdQOpCGtoDLIe2l41fDdM9CYv13X6Vu7UODZtmrRrKfJ9ejUG7RoCKKlUZb6MNJ_YNhNxN5Rz27WZg-_TL6biznTEkW3SsBMC0h08h6G8ng6tLeKXBpEr8wzUeuk5SiwkL73DnBNNlbjoaLsSvahFZ7RcfM_2-TWrVQzpk2Ar4DZPXyOy-ivh5US9ODrGnv_sKJSV9M3IAVvSoEVocK1gc1TStzcEZUdD8VqPHbpvuE';

class DioProvider {
  static final DioProvider _instance = DioProvider._internal();

  factory DioProvider() {
    return _instance;
  }

  DioProvider._internal() {
    dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
        receiveDataWhenStatusError: true,
        maxRedirects: 2,
        baseUrl: "https://www.syriamaksab.com/api/",
        headers: {
          'Authorization': 'Bearer $CHAT_TOKEN',
          'Connection': 'keep-alive'
        }));
  }

  late final Dio dio;

  static Dio getDioInstance() {
    return _instance.dio;
  }
}
