import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/redux/core.dart';
import 'package:linkedin_login/src/server/state.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

/// This class is responsible to fetch all information for user after we get
/// token and code from LinkedIn
class LinkedInAuthCodeWidget extends StatefulWidget {
  final Function(AuthorizationCodeResponse) onGetAuthCode;
  final Function catchError;
  final String redirectUrl;
  final String clientId;
  final AppBar appBar;
  final bool destroySession;

  // just in case that frontend in your team has changed redirect url
  final String frontendRedirectUrl;

  /// Client state parameter needs to be unique range of characters - random one
  LinkedInAuthCodeWidget({
    @required this.onGetAuthCode,
    @required this.redirectUrl,
    @required this.clientId,
    this.frontendRedirectUrl,
    this.destroySession = false,
    this.catchError,
    this.appBar,
  });

  @override
  State createState() => _LinkedInAuthCodeWidgetState();
}

class _LinkedInAuthCodeWidgetState extends State<LinkedInAuthCodeWidget> {
  @override
  void initState() {
    super.initState();

    Session.clientState =
        (Session.clientState == null || Session.clientState.isEmpty)
            ? Uuid().v4()
            : Session.clientState;
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: LinkedInStore.inject().store,
      child: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) => _ViewModel.from(store),
        onDidChange: (viewModel) => widget.onGetAuthCode(
          viewModel.authCode.userAuthCode,
        ),
        builder: (context, viewModel) {
          return LinkedInWebViewHandler(
            config: AuthorizationWebViewConfig(
              destroySession: widget.destroySession,
              frontendRedirectUrl: widget.frontendRedirectUrl,
              redirectUrl: widget.redirectUrl,
              clientId: widget.clientId,
              appBar: widget.appBar,
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel {
  _ViewModel({
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
