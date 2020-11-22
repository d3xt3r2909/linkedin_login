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
  LinkedInAuthCodeWidget({
    @required this.onGetAuthCode,
    @required this.redirectUrl,
    @required this.clientId,
    this.destroySession = false,
    this.frontendRedirectUrl,
    this.catchError,
    this.appBar,
  })  : assert(onGetAuthCode != null),
        assert(redirectUrl != null),
        assert(clientId != null),
        assert(destroySession != null);

  final Function(AuthorizationCodeResponse) onGetAuthCode;
  @Deprecated(
      'From 1.4.x version of library, this field will not be used anymore and in near future it will be removed. Error code will be set inside AuthorizationCodeResponse response [error] property')
  final Function catchError;
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
            WebViewConfigStrategy(
              configuration: AuthCodeConfig(
                destroySession: widget.destroySession,
                frontendRedirectUrlParam: widget.frontendRedirectUrl,
                redirectUrl: widget.redirectUrl,
                clientId: widget.clientId,
                appBar: widget.appBar,
              ),
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
