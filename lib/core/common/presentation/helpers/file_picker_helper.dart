import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/services/logger/logger_service.dart';

/// An abstract interface for a file and media selection service.
///
/// This interface defines methods for selecting files, images, and directories
/// from a device's storage or gallery. It is designed to be platform-agnostic
/// and easily mockable for testing.
abstract class IFileSelectorHelper {
  /// Picks a single file from the device’s file system.
  ///
  /// Optionally, you can filter files by providing a list of [allowedExtensions].
  /// For example:
  /// ```dart
  /// final file = await fileSelector.selectSingleFile(allowedExtensions: ['pdf', 'json']);
  /// ```
  ///
  /// Returns the selected [File], or `null` if the user cancels the selection.
  Future<File?> selectSingleFile({List<String>? allowedExtensions});

  /// Picks multiple files from the device’s file system.
  ///
  /// You can restrict selectable file types using [allowedExtensions].
  /// For example:
  /// ```dart
  /// final files = await fileSelector.selectMultipleFiles(allowedExtensions: ['jpg', 'png']);
  /// ```
  ///
  /// Returns a list of selected [File] objects, or `null` if cancelled.
  Future<List<File>?> selectMultipleFiles({List<String>? allowedExtensions});

  /// Opens the device gallery to pick a single image.
  ///
  /// Returns the selected image as a [File], or `null` if the user cancels.
  Future<File?> selectSingleImageFromGallery();

  /// Opens the device gallery to pick multiple images at once.
  ///
  /// Returns a list of selected image [File] objects.
  /// If the user cancels, an empty list or `null` is returned.
  Future<List<File>?> selectMultipleImagesFromGallery();

  /// Opens a system directory picker to select a directory path.
  ///
  /// Returns the selected directory path as a [String], or `null` if cancelled.
  Future<String?> selectDirectory();
}

/// Concrete implementation of [IFileSelectorHelper] using:
/// - [file_picker] for general file and directory selection
/// - [image_picker] for image selection from gallery
///
/// This class abstracts away platform-specific picker details and provides
/// consistent, testable APIs for file and media selection.
class FileSelectorHelperImpl implements IFileSelectorHelper {
  /// Creates a new instance of [FileSelectorHelperImpl].
  ///
  /// You can inject custom [filePicker] and [imagePicker] instances for testing
  /// or dependency management. By default, it uses:
  /// - [FilePicker.platform]
  /// - [ImagePicker()]
  ///
  /// Pass a [logger] to have picker failures logged before they are rethrown.
  FileSelectorHelperImpl({
    FilePicker? filePicker,
    ImagePicker? imagePicker,
    ILoggerService? logger,
  }) : _filePicker = filePicker ?? FilePicker.platform,
       _imagePicker = imagePicker ?? ImagePicker(),
       _logger = logger;

  final FilePicker _filePicker;
  final ImagePicker _imagePicker;
  final ILoggerService? _logger;

  /// Logs [error] and rethrows it with its original stack trace.
  Never _fail(String operation, Object error, StackTrace stackTrace) {
    _logger?.e(
      'File selection failed: $operation',
      error: error,
      stackTrace: stackTrace,
      name: 'FileSelectorHelper',
    );
    Error.throwWithStackTrace(error, stackTrace);
  }

  /// {@macro IFileSelectorHelper.selectSingleFile}
  @override
  Future<File?> selectSingleFile({List<String>? allowedExtensions}) async {
    try {
      final result = await _filePicker.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e, st) {
      _fail('picking single file', e, st);
    }
    return null;
  }

  /// {@macro IFileSelectorHelper.selectMultipleFiles}
  @override
  Future<List<File>?> selectMultipleFiles({
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await _filePicker.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        return result.paths
            .whereType<String>()
            .map((path) => File(path))
            .toList();
      }
    } catch (e, st) {
      _fail('picking multiple files', e, st);
    }
    return null;
  }

  /// {@macro IFileSelectorHelper.selectSingleImageFromGallery}
  @override
  Future<File?> selectSingleImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e, st) {
      _fail('picking single image', e, st);
    }
    return null;
  }

  /// {@macro IFileSelectorHelper.selectMultipleImagesFromGallery}
  @override
  Future<List<File>?> selectMultipleImagesFromGallery() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage();
      return pickedFiles.map((xfile) => File(xfile.path)).toList();
    } catch (e, st) {
      _fail('picking multiple images', e, st);
    }
  }

  /// {@macro IFileSelectorHelper.selectDirectory}
  @override
  Future<String?> selectDirectory() async {
    try {
      return await _filePicker.getDirectoryPath();
    } catch (e, st) {
      _fail('selecting directory', e, st);
    }
  }
}
