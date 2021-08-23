import 'package:flutter/material.dart';

class AnimatedLoadingButton extends StatelessWidget {
  final Widget child;
  final double heigth;
  final Animation<double> animation;
  Widget? loadingWidget;
  final void Function() onTap;
  AnimatedLoadingButton({
    Key? key,
    required this.child,
    required this.heigth,
    required this.animation,
    this.loadingWidget,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: child,
      animation: animation,
      builder: (context, child) => Container(
        height: heigth,
        width: animation.value + 15,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
            onPressed: onTap,
            child: animation.isCompleted
                ? child
                : Container(
                    width: 20,
                    height: 20,
                    child: loadingWidget ??
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                  )),
      ),
    );
  }
}
