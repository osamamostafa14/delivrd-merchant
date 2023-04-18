import 'package:delivrd_driver/data/repository/auth_repo.dart';
import 'package:delivrd_driver/data/repository/financials_repo.dart';
import 'package:delivrd_driver/data/repository/home_repo.dart';
import 'package:delivrd_driver/data/repository/location_repo.dart';
import 'package:delivrd_driver/data/repository/profile_repo.dart';
import 'package:delivrd_driver/data/repository/splash_repo.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/financials_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/provider/splash_provider.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:delivrd_driver/provider/bank_provider.dart';
import 'package:delivrd_driver/data/repository/bank_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => HomeRepo(dioClient: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => BankRepo(dioClient: sl()));
  sl.registerLazySingleton(() => FinancialsRepo(dioClient: sl()));

  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => HomeProvider(homeRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => BankProvider(bankRepo: sl()));
  sl.registerFactory(() => FinancialsProvider(financialsRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
