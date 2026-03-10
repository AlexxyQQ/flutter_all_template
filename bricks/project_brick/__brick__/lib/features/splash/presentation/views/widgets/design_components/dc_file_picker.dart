import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/locator/service_locator.dart';
import '../../../../../../core/common/presentation/extensions/size/size_extension.dart';
import '../../../../../../core/common/presentation/extensions/theme/theme_extension.dart';
import '../../../../../../core/common/presentation/helpers/file_picker_helper.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_button.dart';
import '../../../../../../core/common/presentation/views/widgets/system/app_divider.dart';
import '../../../../../../core/common/presentation/views/widgets/system/icon/app_icon_widget.dart';
import '../../../../../../core/common/presentation/views/widgets/system/images/app_image_widget.dart';
import '../../../../../../core/common/presentation/views/widgets/system/text/app_text_widget.dart';

class DcFilePicker extends StatefulWidget {
  const DcFilePicker({Key? key}) : super(key: key);

  @override
  State<DcFilePicker> createState() => _DcFilePickerState();
}

class _DcFilePickerState extends State<DcFilePicker> {
  // State variables to hold results for display
  String _statusLog = 'Ready to pick files...';
  List<File> _displayFiles = [];
  bool _isImagePreview = false;

  // Helper to access your service
  IFileSelectorHelper get _fileHelper => sl<IFileSelectorHelper>();

  // 1. Pick Single File
  Future<void> _pickSingleFile() async {
    setState(() => _statusLog = 'Picking single file...');

    final file = await _fileHelper.selectSingleFile(
      allowedExtensions: ['pdf', 'txt', 'json'],
    );

    if (mounted) {
      setState(() {
        if (file != null) {
          _statusLog = "Selected File:\n${file.path.split('/').last}";
          _displayFiles = [file];
          _isImagePreview = false;
        } else {
          _statusLog = 'Selection Cancelled';
        }
      });
    }
  }

  // 2. Pick Multiple Files
  Future<void> _pickMultipleFiles() async {
    setState(() => _statusLog = 'Picking multiple files...');

    final files = await _fileHelper.selectMultipleFiles();

    if (mounted) {
      setState(() {
        if (files != null && files.isNotEmpty) {
          _statusLog = 'Selected ${files.length} files';
          _displayFiles = files;
          _isImagePreview = false;
        } else {
          _statusLog = 'Selection Cancelled';
        }
      });
    }
  }

  // 3. Pick Single Image (Gallery)
  Future<void> _pickSingleImage() async {
    setState(() => _statusLog = 'Opening Gallery...');

    final file = await _fileHelper.selectSingleImageFromGallery();

    if (mounted) {
      setState(() {
        if (file != null) {
          _statusLog = "Selected Image:\n${file.path.split('/').last}";
          _displayFiles = [file];
          _isImagePreview = true;
        } else {
          _statusLog = 'Gallery Closed';
        }
      });
    }
  }

  // 4. Pick Multiple Images (Gallery)
  Future<void> _pickMultipleImages() async {
    setState(() => _statusLog = 'Opening Gallery (Multi)...');

    final files = await _fileHelper.selectMultipleImagesFromGallery();

    if (mounted) {
      setState(() {
        if (files != null && files.isNotEmpty) {
          _statusLog = 'Selected ${files.length} images';
          _displayFiles = files;
          _isImagePreview = true;
        } else {
          _statusLog = 'Gallery Closed';
        }
      });
    }
  }

  // 5. Pick Directory
  Future<void> _pickDirectory() async {
    setState(() => _statusLog = 'Picking Directory...');

    final path = await _fileHelper.selectDirectory();

    if (mounted) {
      setState(() {
        if (path != null) {
          _statusLog = 'Selected Directory:\n$path';
          _displayFiles = []; // No specific files to show
        } else {
          _statusLog = 'Directory Selection Cancelled';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.allPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // Ensures it only takes needed space
        children: [
          // --- Control Panel ---
          const Text(
            'LocaleKeys.common_words_actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          10.verticalGap,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppButton.secondary(
                label: 'LocaleKeys.common_sentences_single_file_pdftxt',
                onPressed: _pickSingleFile,
              ),
              AppButton.secondary(
                label: 'LocaleKeys.common_sentences_multi_files',
                onPressed: _pickMultipleFiles,
              ),
              AppButton.secondary(
                label: 'LocaleKeys.common_sentences_single_image',
                onPressed: _pickSingleImage,
              ),
              AppButton.secondary(
                label: 'LocaleKeys.common_sentences_multi_images',
                onPressed: _pickMultipleImages,
              ),
              AppButton.secondary(
                label: 'LocaleKeys.common_words_directory',
                onPressed: _pickDirectory,
              ),
            ],
          ),
          16.verticalGap,
          AppDivider.horizontal(),
          16.verticalGap,
          // --- Status Log ---
          Container(
            padding: 12.allPadding,
            color: context.colors.inverseSurface,
            child: AppText(_statusLog, style: context.textStyles.bodySmall),
          ),
          12.verticalGap,
          // --- Preview Area ---
          if (_displayFiles.isEmpty)
            Container(
              key: const ValueKey('empty_view_container'), // <--- CRITICAL FIX
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.outline),
                borderRadius: 8.borderCircular,
              ),
              child: AppText(
                'LocaleKeys.common_sentences_no_content_to_display',
                style: context.textStyles.bodySmall,
              ),
            ),

          if (_displayFiles.isNotEmpty)
            // Wrap in a KeyedSubtree or just add key to the widget if possible.
            // Since ConstrainedBox accepts a key, we put it there.
            ConstrainedBox(
              key: const ValueKey('file_list_view'), // <--- CRITICAL FIX
              constraints: BoxConstraints(
                maxHeight: 400.h, // Limit height so it fits in your column
                minHeight: 50,
              ),
              child: ListView.builder(
                shrinkWrap: true, // Crucial for nesting inside Column
                itemCount: _displayFiles.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final file = _displayFiles[index];
                  final fileSizeInKB = file.existsSync()
                      ? (file.lengthSync() / 1024)
                      : 0;

                  return Card(
                    margin: 8.bottomOnly,
                    child: ListTile(
                      leading: _isImagePreview
                          ? AppImage.fromFile(file, width: 50.w, height: 50.h)
                          : AppIcon(Icons.description, size: 40.r),
                      title: AppText(
                        file.path.split('/').last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: AppText(
                        file.path,
                        style: context.textStyles.labelSmall,
                      ),
                      trailing: AppText(
                        '${fileSizeInKB.toStringAsFixed(1)} KB',
                        style: context.textStyles.labelSmall,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
