import 'package:flutter/material.dart';

// Simple responsive wrapper for phone layouts only
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext context, Widget? child) phoneBuilder;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    required this.phoneBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // We'll use the phoneBuilder for all cases since we're focusing only on phones
    return phoneBuilder(context, child);
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    SizingInformation sizingInformation,
  )
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        var mediaQuery = MediaQuery.of(context);
        var sizingInformation = SizingInformation(
          screenSize: mediaQuery.size,
          localWidgetSize: Size(
            boxConstraints.maxWidth,
            boxConstraints.maxHeight,
          ),
        );
        return builder(context, sizingInformation);
      },
    );
  }
}

class SizingInformation {
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation({required this.screenSize, required this.localWidgetSize});
}
