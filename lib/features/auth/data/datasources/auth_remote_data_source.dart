import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModels> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModels> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModels?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModels> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user == null
          ? throw const ServerException('User is null')
          : UserModels.fromJson(response.user!.toJson()).copyWith(
              email: currentUserSession!.user.email,
            );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModels> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          "name": name,
        },
      );
      return response.user == null
          ? throw const ServerException('User is null')
          : UserModels.fromJson(response.user!.toJson()).copyWith(
              email: currentUserSession!.user.email,
            );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModels?> getCurrentUserData() async {
    try {
      final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq(
            'id',
            currentUserSession!.user.id,
          );
      // ignore: unnecessary_null_comparison
      return userData == null
          ? null
          : UserModels.fromJson(userData.first).copyWith(
              email: currentUserSession!.user.email,
            );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
