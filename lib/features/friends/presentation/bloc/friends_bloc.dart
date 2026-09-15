import 'package:base_bloc_3/features/chat/domain/entity/index.dart';
import 'package:base_bloc_3/features/friends/domain/repository/friends_repository.dart';
import 'package:base_bloc_3/import.dart';

part 'friends_bloc.freezed.dart';

part 'friends_bloc.g.dart';

part 'friends_event.dart';

part 'friends_state.dart';

@injectable
class FriendsBloc extends BaseBloc<FriendsEvent, FriendsState> {
  FriendsBloc(this._repo) : super(FriendsState.init()) {
    on<FriendsEvent>((FriendsEvent event, Emitter<FriendsState> emit) async {
      await event.when(
        loadData: () => _loadData(emit),
        sendRequest: (peerId) => _sendRequest(emit, peerId),
        cancelRequest: (peerId) => _cancelRequest(emit, peerId),
        acceptRequest: (peerId) => acceptRequest(emit, peerId),
        removeFriend: (peerId) => _removeFriend(emit, peerId),
      );
    });
  }

  final FriendsRepo _repo;
  final ValueNotifier<Set<String>> processingIds = ValueNotifier({});

  bool isProcessing(String uid) => processingIds.value.contains(uid);

  void _startProcessing(String uid) {
    processingIds.value = {...processingIds.value, uid};
  }

  void _stopProcessing(String uid) {
    processingIds.value = {...processingIds.value}..remove(uid);
  }

  @override
  Future<void> close() {
    processingIds.dispose();
    return super.close();
  }

  Future onInit(Emitter<FriendsState> emit) async {}

  Future<void> _loadData(Emitter<FriendsState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    final userRes = await _repo.getAllUsers();
    final friendsRes = await _repo.getFriends();
    final incomingRes = await _repo.getIncomingRequest();
    final outgoingRes = await _repo.getOutgoingRequest();

    userRes.fold(
        (error) => emit(
              state.copyWith(
                status: BaseStateStatus.failed,
                message: error.toString(),
              ),
            ), (users) {
      friendsRes.fold(
          (e) => emit(
                state.copyWith(
                  status: BaseStateStatus.failed,
                  message: e.toString(),
                ),
              ), (friends) {
        incomingRes.fold(
            (e) => emit(
                  state.copyWith(
                    status: BaseStateStatus.failed,
                    message: e.toString(),
                  ),
                ), (incoming) {
          outgoingRes.fold(
            (e) => emit(
              state.copyWith(
                status: BaseStateStatus.failed,
                message: e.toString(),
              ),
            ),
            (outgoing) => emit(
              state.copyWith(
                status: BaseStateStatus.success,
                users: users,
                friends: friends,
                incomingRequests: incoming,
                outgoingRequests: outgoing,
              ),
            ),
          );
        });
      });
    });
  }

  Future<void> _sendRequest(Emitter<FriendsState> emit, String peerId) async {
    if (isProcessing(peerId)) return;
    _startProcessing(peerId);

    final resp = await _repo.sendFriendRequest(peerId);
    resp.fold(
      (e) => emit(state.copyWith(
        status: BaseStateStatus.failed,
        message: e.toString(),
      )),
      (_) {
        final user = _findUser(state.users, peerId);
        final outgoing = [...state.outgoingRequests];
        if (user != null && !outgoing.any((item) => item.uid == peerId)) {
          outgoing.add(user);
        }
        emit(state.copyWith(
          status: BaseStateStatus.success,
          outgoingRequests: outgoing,
        ));
      },
    );
    _stopProcessing(peerId);
  }

  Future<void> _cancelRequest(Emitter<FriendsState> emit, String peerId) async {
    if (isProcessing(peerId)) return;
    _startProcessing(peerId);

    final resp = await _repo.cancelFriendRequest(peerId);
    resp.fold(
      (e) => emit(state.copyWith(
        status: BaseStateStatus.failed,
        message: e.toString(),
      )),
      (_) {
        emit(state.copyWith(
          status: BaseStateStatus.success,
          outgoingRequests: state.outgoingRequests
              .where((item) => item.uid != peerId)
              .toList(),
        ));
      },
    );
    _stopProcessing(peerId);
  }

  Future<void> acceptRequest(Emitter<FriendsState> emit, String peerId) async {
    if (isProcessing(peerId)) return;
    _startProcessing(peerId);

    final resp = await _repo.acceptFriendRequest(peerId);
    resp.fold(
      (e) => emit(state.copyWith(
        status: BaseStateStatus.failed,
        message: e.toString(),
      )),
      (_) {
        final user = _findUser(state.incomingRequests, peerId);
        final friends = [...state.friends];
        if (user != null && !friends.any((item) => item.uid == peerId)) {
          friends.add(user);
        }
        emit(state.copyWith(
          status: BaseStateStatus.success,
          friends: friends,
          incomingRequests: state.incomingRequests
              .where((item) => item.uid != peerId)
              .toList(),
        ));
      },
    );
    _stopProcessing(peerId);
  }

  Future<void> _removeFriend(Emitter<FriendsState> emit, String peerId) async {
    if (isProcessing(peerId)) return;
    _startProcessing(peerId);

    final resp = await _repo.removeFriend(peerId);
    resp.fold(
      (e) => emit(state.copyWith(
        status: BaseStateStatus.failed,
        message: e.toString(),
      )),
      (_) {
        emit(state.copyWith(
          status: BaseStateStatus.success,
          friends: state.friends
              .where((item) => item.uid != peerId)
              .toList(),
        ));
      },
    );
    _stopProcessing(peerId);
  }

  UserEntity? _findUser(List<UserEntity> users, String uid) {
    for (final user in users) {
      if (user.uid == uid) return user;
    }
    return null;
  }
}
