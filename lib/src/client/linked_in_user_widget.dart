import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/redux/core.dart';
import 'package:linkedin_login/src/client/state.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

/// This class is responsible to fetch all information for user after we get
/// token and code from LinkedIn
class LinkedInUserWidget extends StatefulWidget {
  final Function(LinkedInUserModel) onGetUserProfile;
  final Function catchError;
  final String redirectUrl;
  final String clientId, clientSecret;
  final PreferredSizeWidget appBar;
  final bool destroySession;
  final List<String> projection;

  /// Client state parameter needs to be unique range of characters - random one
  LinkedInUserWidget({
    @required this.onGetUserProfile,
    @required this.redirectUrl,
    @required this.clientId,
    @required this.clientSecret,
    this.catchError,
    this.destroySession = false,
    this.appBar,
    this.projection = const [
      ProjectionParameters.id,
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
    ],
  })  : assert(onGetUserProfile != null),
        assert(redirectUrl != null),
        assert(clientId != null),
        assert(clientSecret != null),
        assert(destroySession != null),
        assert(projection != null);

  @override
  State createState() => _LinkedInUserWidgetState();
}

/// Class [_LinkedInUserWidgetState] is handling changes after user is singed in
/// which will have as result user profile on the end
class _LinkedInUserWidgetState extends State<LinkedInUserWidget> {
  String urlLinkedInUserProfile = 'https://api.linkedin.com/v2/me';
  final urlLinkedInEmailAddress =
      'https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))';
  bool showProgress = false;

  @override
  void initState() {
    super.initState();

    Session.clientState = Uuid().v4();
    String projection = 'projection=(${widget.projection.join(",")})';
    urlLinkedInUserProfile = '$urlLinkedInUserProfile?$projection';
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: LinkedInStore.inject().store,
      child: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) => _ViewModel.from(store),
        onDidChange: (viewModel) => widget.onGetUserProfile(
          viewModel.user.linkedInUser,
        ),
        builder: (context, viewModel) {
          return LinkedInWebViewHandler(
            AuthorizationWebViewConfig(
              destroySession: widget.destroySession,
              redirectUrl: widget.redirectUrl,
              clientSecret: widget.clientSecret,
              clientId: widget.clientId,
              appBar: widget.appBar,
            ),
            clientSecret: widget.clientSecret,
          );
        },
      ),
    );
  }
}

class _ViewModel {
  _ViewModel({
    @required this.onDispatch,
    @required this.user,
  }) : assert(onDispatch != null);

  factory _ViewModel.from(Store<AppState> store) {
    return _ViewModel(
      user: store.state.linkedInUserState,
      onDispatch: (action) => store.dispatch(action),
    );
  }

  final LinkedInUserState user;
  final Function(dynamic) onDispatch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          user == other.user;

  @override
  int get hashCode => user.hashCode;
}
