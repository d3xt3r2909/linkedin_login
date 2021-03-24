import 'package:flutter/widgets.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';

@immutable
class InjectorWidget extends InheritedWidget {
  const InjectorWidget({
    Key? key,
    required Widget child,
    required this.graph,
  }) : super(key: key, child: child);

  static Graph? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InjectorWidget>()!.graph;
  }

  final Graph? graph;

  @override
  bool updateShouldNotify(InjectorWidget oldWidget) => false;
}
