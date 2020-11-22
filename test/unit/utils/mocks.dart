import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

class MockStore extends Mock implements Store<AppState> {}
// ignore: must_be_immutable
class MockGraph extends Mock implements Graph {}
