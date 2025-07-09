import 'dart:io';

import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectorTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    setState(() {
      image = pickedImage;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.done_rounded,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: selectImage,
                child: image != null
                    ? SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: const Radius.circular(12),
                          color: AppPalette.borderColor,
                          dashPattern: [12, 4],
                          strokeCap: StrokeCap.round,
                        ),
                        child: const SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 40,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Select your image',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      [
                            'Technology',
                            'Business',
                            'Programming',
                            'Entertainment',
                          ]
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(4),
                              child: GestureDetector(
                                onTap: () {
                                  selectorTopics.contains(e)
                                      ? selectorTopics.remove(e)
                                      : selectorTopics.add(e);
                                  setState(() {});
                                },
                                child: Chip(
                                  label: Text(e),
                                  color: selectorTopics.contains(e)
                                      ? WidgetStatePropertyAll(
                                          AppPalette.gradient1,
                                        )
                                      : null,
                                  side: selectorTopics.contains(e)
                                      ? null
                                      : BorderSide(
                                          color: AppPalette.borderColor,
                                        ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              BlogEditor(
                controller: titleController,
                hintText: 'Blog title',
              ),
              const SizedBox(
                height: 12,
              ),
              BlogEditor(
                controller: contentController,
                hintText: 'Blog content',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
