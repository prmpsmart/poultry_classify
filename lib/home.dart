// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poultry_classify/backend.dart';
import 'package:poultry_classify/constants.dart';
import 'package:poultry_classify/in_app_notification.dart';
import 'package:poultry_classify/loader.dart';
import 'package:poultry_classify/utils.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final String email;
  const Home(this.email, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imagePicker = ImagePicker();
  Uint8List imageBytes = Uint8List(0);

  @override
  initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      getExternalDocumentPath,
    );
  }

  Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<void> writeToFile(String disease) async {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);
    final fileName = '$disease-$formattedDateTime.png';

    String filePath = join(await _localPath, fileName);
    File file = File(filePath);

    try {
      await file.writeAsBytes(imageBytes, flush: true);
      InAppNotification.show(context, 'Image saved to: $filePath');
    } catch (e) {
      InAppNotification.show(context, 'Error saving image: $e', isError: true);
    }
  }

  pickImage(BuildContext context, ImageSource imageSource) async {
    imageBytes = Uint8List(0);
    ;

    XFile? image =
        await imagePicker.pickImage(source: imageSource, imageQuality: 50);

    if (image != null) {
      imageBytes = await image.readAsBytes();
      classify();
    }
  }

  final api = ApiService();

  bool isLoading = false;

  String result = "Result will be displayed here...";

  classify() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await api.classify(
        image: imageBytes,
      );
      final success = data['status'] == 200;
      InAppNotification.show(
        context,
        data['detail'],
        isError: !success,
      );
      final disease = data['disease'];
      final diseaseImage = data['disease_image'];

      if (disease != null) {
        result = disease;
      }

      if (diseaseImage != null) {
        imageBytes = base64Decode(diseaseImage);
      }

      setState(() {
        writeToFile(disease);
      });
    } catch (e) {
      InAppNotification.show(
        context,
        e.toString(),
        isError: true,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Container(
              padding: EdgeInsets.only(
                top: 40.w,
                bottom: 40.w,
                left: 20.w,
                right: 20.w,
              ),
              width: 1.sw,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Hello,',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.spMin,
                                ),
                              ),
                              Text(
                                ' ${widget.email}',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.spMin,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(5.r),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Image.asset(
                              'assets/dp.png',
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "It is time to check your birds's health",
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (imageBytes.isEmpty)
                        Image.asset(
                          'assets/classify.png',
                          width: 1.sw,
                        ),
                      if (imageBytes.isNotEmpty)
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Image.memory(imageBytes),
                        ),
                      Container(
                        height: 70.h,
                        width: 1.sw,
                        margin: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: Text(
                            result,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.spMin,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: classify,
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle_outlined,
                                  color: primaryColor,
                                ),
                                10.horizontalSpace,
                                const Text(
                                  'Reload',
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, 'history'),
                            icon: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle_outlined,
                                  color: Colors.green,
                                ),
                                10.horizontalSpace,
                                const Text(
                                  'History',
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await pickImage(context, ImageSource.gallery);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        color: primaryColor,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                            ),
                            10.horizontalSpace,
                            Text(
                              'Gallery',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.spMin,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          await pickImage(context, ImageSource.camera);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        color: primaryColor,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.camera_enhance,
                              color: Colors.white,
                            ),
                            10.horizontalSpace,
                            Text(
                              'Camera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.spMin,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
