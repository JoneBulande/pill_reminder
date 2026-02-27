import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  //
  final Color headerColor;
  final EdgeInsetsGeometry headerPadding;
  final Widget headerContent;
  final Color bodyColor;
  final int flex;
  final EdgeInsetsGeometry bodyPadding;
  final Widget bodyContent;
  //
  const MyContainer({
    super.key,
    required this.flex,
    required this.bodyColor,
    required this.headerColor,
    required this.bodyPadding,
    required this.bodyContent,
    required this.headerPadding,
    required this.headerContent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: headerColor,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: headerPadding,
                child: headerContent,
              ),
            ),
            Expanded(
              flex: flex,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: bodyColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(17),
                  ),
                ),
                child: Padding(
                  padding: bodyPadding,
                  child: bodyContent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
