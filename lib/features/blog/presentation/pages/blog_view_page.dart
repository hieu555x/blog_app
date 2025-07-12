import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogDeleteSuccess) {
          showSnackBar(context, 'Blog đã được xóa thành công!');
          Navigator.of(context).pop(); // Quay về trang trước
        } else if (state is BlogFailure) {
          showSnackBar(context, 'Lỗi: ${state.error}');
        }
      },
      builder: (context, state) {
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
            actions: [
              // Hiển thị nút delete nếu user là chủ của blog
              BlocBuilder<AppUserCubit, AppUserState>(
                builder: (context, userState) {
                  final isOwner =
                      userState is AppUserLoggedIn &&
                      userState.user.id == blog.posterId;

                  if (isOwner) {
                    return IconButton(
                      onPressed: state is BlogLoading
                          ? null
                          : () {
                              _showDeleteConfirmDialog(context);
                            },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                        size: 26,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
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
                      borderRadius: BorderRadius.circular(16),
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
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa blog "${blog.title}"?'),
          backgroundColor: AppPalette.backgroundColor,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Gọi delete blog event
                context.read<BlogBloc>().add(BlogDelete(blogId: blog.id));
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
