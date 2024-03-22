import 'package:flutter/widgets.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';

@immutable
class InjectorWidget extends InheritedWidget {
  const InjectorWidget({
    required super.child,
    required this.graph,
    super.key,
  });

  static Graph of(final BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InjectorWidget>()!.graph;
  }

  final Graph graph;

  @override
  bool updateShouldNotify(final InjectorWidget oldWidget) => false;
}
