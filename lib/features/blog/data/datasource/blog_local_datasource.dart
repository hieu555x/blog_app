import 'package:blog_app/features/blog/data/models/blog_models.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDatasource {
  void uploadLocalBlogs({required List<BlogModels> blog});
  List<BlogModels> loadBlog();
  void deleteBlogLocal(String blogId);
}

class BlogLocalDataSourceImpl implements BlogLocalDatasource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModels> loadBlog() {
    List<BlogModels> blogs = [];
    for (int i = 0; i < box.length; i++) {
      blogs.add(
        BlogModels.fromJson(Map<String, dynamic>.from(box.get(i.toString()))),
      );
    }
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModels> blog}) {
    box.clear();
    for (int i = 0; i < blog.length; i++) {
      box.put(i.toString(), blog[i].toJson());
    }
  }

  @override
  void deleteBlogLocal(String blogId) {
    // Tìm và xóa blog có id tương ứng trong local storage
    List<BlogModels> currentBlogs = loadBlog();
    currentBlogs.removeWhere((blog) => blog.id == blogId);
    uploadLocalBlogs(blog: currentBlogs);
  }
}
