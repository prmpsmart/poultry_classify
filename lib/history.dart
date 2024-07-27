import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poultry_classify/constants.dart';
import 'package:poultry_classify/loader.dart';
import 'package:poultry_classify/utils.dart';

class Disease {
  final String name;
  final File image;
  final String datetime;

  Disease({
    required this.name,
    required this.image,
    required this.datetime,
  });
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Disease> diseases = [];
  bool loading = true;

  @override
  initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () async {
      final folderPath = await getExternalDocumentPath();

      if (Directory(folderPath).existsSync()) {
        List<FileSystemEntity> files = Directory(folderPath).listSync();

        // Parse filename back into DateTime
        RegExp regex = RegExp(r'(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})');

        // Filter out only image files (you can customize this based on your requirements)
        List<File> imageFiles = files
            .where((file) {
              return file.path.toLowerCase().endsWith('.png');
            })
            .map((file) => File(file.path))
            .toList();

        // Print the list of image files
        for (var imageFile in imageFiles) {
          final filename = imageFile.path.split('/').last;

          final firstIndex = filename.indexOf('-');
          final lastIndex = filename.lastIndexOf('.');
          final disease = filename.substring(0, firstIndex);
          final datetimeString = filename.substring(firstIndex, lastIndex);

          String extractedDateTimeStr =
              regex.firstMatch(datetimeString)?.group(1) ?? '';

          if (extractedDateTimeStr.isNotEmpty) {
            diseases.add(Disease(
              datetime: extractedDateTimeStr,
              name: disease,
              image: imageFile,
            ));
          }
        }
        setState(() {
          loading = false;
        });
        //
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: loading,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: 1.sw,
            height: 1.sh,
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 20.w,
            ),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20.spMin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                20.verticalSpace,
                SizedBox(
                  height: .87.sh,
                  width: 1.sw - 40.w,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: diseases.length,
                          itemBuilder: (context, index) {
                            final disease = diseases[index];

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              margin: EdgeInsets.only(bottom: 10.h),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: [
                                  Image.file(
                                    disease.image,
                                    fit: BoxFit.contain,
                                  ),
                                  Container(
                                    width: 1.sw,
                                    padding: EdgeInsets.zero,
                                    color: primaryColor,
                                    child: Column(
                                      children: [
                                        Text(
                                          disease.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.spMin,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          disease.datetime,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.spMin,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
