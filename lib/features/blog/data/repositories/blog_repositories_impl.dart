import 'dart:io';

import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connect_checker.dart';
import 'package:blog_app/features/blog/data/datasource/blog_local_datasource.dart';
import 'package:blog_app/features/blog/data/datasource/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_models.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoriesImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDatasource blogLocalDatasource;
  final ConnectChecker connectChecker;
  BlogRepositoriesImpl(
    this.blogRemoteDataSource,
    this.blogLocalDatasource,
    this.connectChecker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      BlogModels blogModels = BlogModels(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updateAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModels,
      );

      blogModels = blogModels.copyWith(
        imageUrl: imageUrl,
      );
      final uploadBlog = await blogRemoteDataSource.uploadBlog(blogModels);
      return right(uploadBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlog() async {
    try {
      if (!await (connectChecker.isConnected)) {
        final blogs = blogLocalDatasource.loadBlog();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDatasource.uploadLocalBlogs(blog: blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog({
    required String blogId,
  }) async {
    try {
      if (!await (connectChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      // Xóa blog từ server
      await blogRemoteDataSource.deleteBlog(blogId);

      // Xóa blog từ local storage
      blogLocalDatasource.deleteBlogLocal(blogId);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
