import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const cloudName = "waobnfz0";

  static const uploadPreset =
      "flutter_upload";

  static const documentUploadPreset =
      "flutter_document_upload";

  static Future<String?> uploadAvatar(
    File file,
  ) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request =
        http.MultipartRequest(
      "POST",
      url,
    );

    request.fields["upload_preset"] =
        uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        file.path,
      ),
    );

    final response =
        await request.send();

    final res =
        await response.stream.bytesToString();

    final data =
        json.decode(res);

    return data["secure_url"];
  }

  static Future<String?> uploadDocument(
    PlatformFile file,
  ) async {
    if (file.bytes == null) {
      return null;
    }

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/raw/upload",
    );

    final request =
        http.MultipartRequest(
      "POST",
      url,
    );

    request.fields["upload_preset"] =
        documentUploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        file.bytes!,
        filename: file.name,
      ),
    );

    final response =
        await request.send();

    final res =
        await response.stream.bytesToString();

    print(
      "CLOUDINARY STATUS: ${response.statusCode}",
    );

    print(
      "CLOUDINARY RESPONSE: $res",
    );

    if (response.statusCode != 200) {
      return null;
    }

    final data =
        json.decode(res);

    return data["secure_url"];
  }
}