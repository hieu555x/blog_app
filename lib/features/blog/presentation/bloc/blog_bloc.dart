import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecase/upload_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required DeleteBlog deleteBlog,
  }) : _uploadBlog = uploadBlog,
       _getAllBlogs = getAllBlogs,
       _deleteBlog = deleteBlog,
       super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogDelete>(_onBlogDelete);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(
        BlogsUploadSuccess(),
      ),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }

  void _onBlogDelete(
    BlogDelete event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _deleteBlog(DeleteBlogParams(blogId: event.blogId));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) {
        emit(BlogDeleteSuccess());
        // Sau khi xóa thành công, tự động tải lại danh sách blog
        add(BlogFetchAllBlogs());
      },
    );
  }
}
