import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/models/blog_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModels> uploadBlog(BlogModels blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModels blog,
  });
  Future<List<BlogModels>> getAllBlogs();
  Future<void> deleteBlog(String blogId);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<BlogModels> uploadBlog(BlogModels blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();

      return BlogModels.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModels blog,
  }) async {
    try {
      await supabaseClient.storage
          .from('blog_image')
          .upload(
            blog.id,
            image,
          );

      return supabaseClient.storage
          .from('blog_image')
          .getPublicUrl(
            blog.id,
          );
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModels>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*,profiles (name)');
      return blogs
          .map(
            (blog) => BlogModels.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try {
      // Xóa ảnh từ storage trước
      await supabaseClient.storage.from('blog_image').remove([blogId]);

      // Sau đó xóa blog từ database
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
