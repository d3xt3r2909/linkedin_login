import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/client/epic.dart';
import 'package:linkedin_login/src/server/epic.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/epic.dart';
import 'package:redux_epics/redux_epics.dart';

Epic<AppState> epics(Graph graph) => combineEpics<AppState>(
      [
        webViewEpics(graph),
        clientEpics(graph),
        serverEpics(graph),
      ],
    );
