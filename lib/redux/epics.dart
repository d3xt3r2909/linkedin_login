import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/client/epic.dart';
import 'package:linkedin_login/src/webview/epic.dart';
import 'package:redux_epics/redux_epics.dart';

Epic<AppState> epics() => combineEpics<AppState>(
      [
        webViewEpics(),
        clientEpics(),
      ],
    );
