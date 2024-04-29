import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class InAppNotification extends StatefulWidget {
  const InAppNotification({
    required this.message,
    this.isError = false,
    super.key,
  });
  final String message;
  final bool isError;

  @override
  State<StatefulWidget> createState() => _InAppNotificationState();

  static Future<void> show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) async {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) => InAppNotification(
        message: message,
        isError: isError,
      ),
    );
    Navigator.of(context).overlay?.insert(overlayEntry);
    await Future<dynamic>.delayed(
      const Duration(
        seconds: 2,
      ),
    );
    overlayEntry.remove();
  }
}

class _InAppNotificationState extends State<InAppNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    position =
        Tween<Offset>(begin: const Offset(0, -4), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: Curves.bounceInOut),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
              child: SlideTransition(
                position: position,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: widget.isError ? Colors.red : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10).r,
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
