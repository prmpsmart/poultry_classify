import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poultry_classify/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imagePicker = ImagePicker();
  Uint8List imageBytes = Uint8List(0);

  pickImage(BuildContext context, ImageSource imageSource) async {
    imageBytes = Uint8List(0);
    ;

    XFile? image =
        await imagePicker.pickImage(source: imageSource, imageQuality: 50);

    if (image != null) {
      imageBytes = await image.readAsBytes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              ' prmpsmart@gmail.com',
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
                  children: [
                    if (imageBytes.isEmpty)
                      Image.asset(
                        'assets/classify.png',
                        width: 1.sw,
                      ),
                    if (imageBytes.isNotEmpty) Image.memory(imageBytes),
                    20.verticalSpace,
                    Container(
                      height: 100.h,
                      width: 1.sw,
                      color: primaryColor,
                      child: Center(
                        child: Text(
                          "Result will be displayed here...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.spMin,
                          ),
                        ),
                      ),
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
                        print(imageBytes.length);
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
    );
  }
}