import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/redux/core.dart';
import 'package:linkedin_login/src/server/state.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/initializer.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

/// This class is responsible to fetch all information for user after we get
/// token and code from LinkedIn
class LinkedInAuthCodeWidget extends StatefulWidget {
  const LinkedInAuthCodeWidget({
    @required this.onGetAuthCode,
    @required this.redirectUrl,
    @required this.clientId,
    this.destroySession = false,
    this.frontendRedirectUrl,
    this.appBar,
  })  : assert(onGetAuthCode != null),
        assert(redirectUrl != null),
        assert(clientId != null),
        assert(destroySession != null);

  final Function(AuthorizationCodeResponse) onGetAuthCode;
  final String redirectUrl;
  final String clientId;
  final AppBar appBar;
  final bool destroySession;

  // just in case that frontend in your team has changed redirect url
  final String frontendRedirectUrl;

  @override
  State createState() => _LinkedInAuthCodeWidgetState();
}

class _LinkedInAuthCodeWidgetState extends State<LinkedInAuthCodeWidget> {
  Graph graph;

  @override
  void initState() {
    super.initState();

    graph = Initializer().initialise(
      AuthCodeConfig(
        urlState: Uuid().v4(),
        redirectUrlParam: widget.redirectUrl,
        clientIdParam: widget.clientId,
        frontendRedirectUrlParam: widget.frontendRedirectUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InjectorWidget(
      graph: graph,
      child: StoreProvider<AppState>(
        store: LinkedInStore.inject(graph).store,
        child: StoreConnector<AppState, _ViewModel>(
          distinct: true,
          converter: (store) => _ViewModel.from(store),
          onDidChange: (viewModel) => widget.onGetAuthCode(
            viewModel.authCode.userAuthCode,
          ),
          builder: (context, viewModel) {
            return LinkedInWebViewHandler(
              appBar: widget.appBar,
              destroySession: widget.destroySession,
            );
          },
        ),
      ),
    );
  }
}

@immutable
class _ViewModel {
  const _ViewModel({
    @required this.onDispatch,
    @required this.authCode,
  }) : assert(onDispatch != null);

  factory _ViewModel.from(Store<AppState> store) {
    return _ViewModel(
      authCode: store.state.userAuthCodeState,
      onDispatch: (action) => store.dispatch(action),
    );
  }

  final UserAuthCodeState authCode;
  final Function(dynamic) onDispatch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          authCode == other.authCode;

  @override
  int get hashCode => authCode.hashCode;
}
