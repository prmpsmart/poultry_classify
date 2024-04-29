import "package:flutter/material.dart";
import "package:poultry_classify/constants.dart";

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
    this.opacity = 0.5,
    this.progressIndicator = const CircularProgressIndicator(
      backgroundColor: primaryColor,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
    this.color,
  });
  final bool? isLoading;
  final double opacity;
  final Color? color;
  final Widget progressIndicator;
  final Widget? child;

  @override
  LoadingOverlayState createState() => LoadingOverlayState();
}

class LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
  LoadingOverlayState();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool? _overlayVisible;

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.forward) {
        setState(() => _overlayVisible = true);
      }
      if (status == AnimationStatus.dismissed) {
        setState(() => _overlayVisible = false);
      }
    });
    if (widget.isLoading!) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isLoading! && widget.isLoading!) {
      _controller.forward();
    }

    if (oldWidget.isLoading! && !widget.isLoading!) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[widget.child!];

    if (_overlayVisible ?? true) {
      FadeTransition modal = FadeTransition(
        opacity: _animation,
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: widget.opacity,
              child: ModalBarrier(
                dismissible: false,
                color: widget.color ?? const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
            Center(child: widget.progressIndicator),
          ],
        ),
      );
      widgets.add(modal);
    }

    return IgnorePointer(
      ignoring: _overlayVisible!,
      child: Stack(children: widgets),
    );
  }
}
