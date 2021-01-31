// import 'package:linkedin_login/linkedin_login.dart';
// import 'package:linkedin_login/redux/app_state.dart';
// import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
// import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
// import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
// import 'package:linkedin_login/src/server/actions.dart';
// import 'package:linkedin_login/src/server/epic.dart';
// import 'package:linkedin_login/src/utils/configuration.dart';
// import 'package:linkedin_login/src/utils/startup/graph.dart';
// import 'package:mockito/mockito.dart';
// import 'package:redux_epics/redux_epics.dart';
// import 'package:test/test.dart';
//
// import '../../utils/mocks.dart';
// import '../../utils/stream_utils.dart';
//
// void main() {
//   EpicStore<AppState> store;
//   Graph graph;
//   _ArrangeBuilder builder;
//
//   setUp(() {
//     final mockStore = MockStore();
//     graph = MockGraph();
//     store = EpicStore(mockStore);
//
//     builder = _ArrangeBuilder(
//       graph,
//       store,
//       MockAuthorizationRepository(),
//       MockUserRepository(),
//       MockConfiguration(),
//     );
//   });
//
//   const urlAfterSuccessfulLogin =
//       'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA';
//
//   test('Emits FetchAuthCodeFailedAction if state code is not valid', () async {
//     final exception = Exception();
//     builder.withAuthCodeError(exception);
//
//     final events = serverEpics(graph)(
//       toStream(
//         FetchAuthCode(
//           '$urlAfterSuccessfulLogin&state=null',
//         ),
//       ),
//       store,
//     );
//
//     expect(
//       events,
//       emits(
//         FetchAuthCodeFailedAction(exception),
//       ),
//     );
//   });
//
//   test('Emits FetchAuthCodeSucceededAction on success', () async {
//     builder.withAuthCode();
//
//     final events = serverEpics(graph)(
//       toStream(
//         FetchAuthCode(
//           '$urlAfterSuccessfulLogin&state=state',
//         ),
//       ),
//       store,
//     );
//
//     expect(
//       events,
//       emits(FetchAuthCodeSucceededAction(AuthorizationCodeResponse())),
//     );
//   });
// }
//
// class _ArrangeBuilder {
//   _ArrangeBuilder(
//     this.graph,
//     this.store,
//     this.authorizationRepository,
//     this.userRepository,
//     this.configuration,
//   ) : api = MockApi() {
//     when(graph.api).thenReturn(api);
//     when(graph.authorizationRepository).thenReturn(authorizationRepository);
//     when(graph.userRepository).thenReturn(userRepository);
//     when(graph.linkedInConfiguration).thenReturn(configuration);
//
//     withConfiguration();
//   }
//
//   final Graph graph;
//   final LinkedInApi api;
//   final AuthorizationRepository authorizationRepository;
//   final UserRepository userRepository;
//   final EpicStore<AppState> store;
//   final Config configuration;
//
//   void withAuthCode() {
//     when(authorizationRepository.fetchAuthorizationCode(
//       redirectedUrl: anyNamed('redirectedUrl'),
//       clientState: anyNamed('clientState'),
//     )).thenAnswer(
//       (_) => AuthorizationCodeResponse(
//         state: 'state',
//         code: 'code',
//       ),
//     );
//   }
//
//   void withAuthCodeError([Exception exception]) {
//     when(authorizationRepository.fetchAuthorizationCode(
//       redirectedUrl: anyNamed('redirectedUrl'),
//       clientState: anyNamed('clientState'),
//     )).thenThrow(exception ?? Exception());
//   }
//
//   void withConfiguration() {
//     when(configuration.clientSecret).thenAnswer((_) => 'clientSecret');
//     when(configuration.projection).thenAnswer((_) => ['projection1']);
//     when(configuration.redirectUrl)
//         .thenAnswer((_) => 'https://redirectUrl.com');
//     when(configuration.frontendRedirectUrl)
//         .thenAnswer((_) => 'https://frontendRedirectUrl.com');
//     when(configuration.clientId).thenAnswer((_) => 'clientId');
//     when(configuration.state).thenAnswer((_) => 'state');
//     when(configuration.initialUrl).thenAnswer((_) => 'initialUrl');
//   }
// }
