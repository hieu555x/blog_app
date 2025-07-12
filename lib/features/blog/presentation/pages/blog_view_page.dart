import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reaading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewPage extends StatelessWidget {
  static route(Blog blog) => MaterialPageRoute(
    builder: (context) => BlogViewPage(
      blog: blog,
    ),
  );
  final Blog blog;
  const BlogViewPage({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          blog.title,
          style: TextStyle(
            fontSize: AppPalette.titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By ${blog.posterName}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: AppPalette.posterNameSize,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${formatDateByDDMMYYYY(blog.updateAt)} at ${formatTimeHHMMSS(blog.updateAt)} . ${calculateReadingTime(blog.content)} min',
                  style: TextStyle(
                    color: AppPalette.greyColor,
                    fontSize: AppPalette.posterNameSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: Image.network(
                    blog.imageUrl,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  blog.content,
                  style: TextStyle(
                    fontSize: AppPalette.posterNameSize,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
