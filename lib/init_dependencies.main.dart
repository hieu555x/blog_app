part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );
  Hive.init((await getApplicationDocumentsDirectory()).path);
  final box = await Hive.openBox('blogs');

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(
    () => box,
  );
  serviceLocator.registerFactory(() => InternetConnection());
  //Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  //Auth
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CurrentUser(serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => UserLogout(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      userLogout: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  //Blog
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(
      supabaseClient: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<BlogLocalDatasource>(
    () => BlogLocalDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoriesImpl(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UploadBlog(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetAllBlogs(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => DeleteBlog(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
      deleteBlog: serviceLocator(),
    ),
  );
}
