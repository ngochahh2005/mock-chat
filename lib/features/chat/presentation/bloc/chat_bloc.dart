import 'package:base_bloc_3/features/chat/domain/entity/index.dart';
import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/generated/intl/messages_en.dart';
import 'package:base_bloc_3/import.dart';

part 'chat_bloc.freezed.dart';

part 'chat_bloc.g.dart';

part 'chat_event.dart';

part 'chat_state.dart';

@injectable
class ChatBloc extends BaseBloc<ChatEvent, ChatState> {
  final ChatRepo _repo;

  ChatBloc(this._repo) : super(ChatState.init()) {
    on<ChatEvent>((event, emit) async {
      await event.when(
        fetchMyRooms: () => _onFetchMyRooms(emit),
        searchUser: (username) => _onSearchUser(emit, username),
        clearSearch: () => _onClearSearch(emit),
      );
    });
  }


  Future<void> _onFetchMyRooms(Emitter<ChatState> emit) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    try {
      await emit.forEach<List<ChatRoomEntity>>(
        _repo.getMyChatRooms(),
        onData: (rooms) =>
            state.copyWith(status: BaseStateStatus.success, rooms: rooms),
        onError: (error, stackTrace) =>
            state.copyWith(status: BaseStateStatus.failed),
      );
    } catch (e) {
      emit(state.copyWith(status: BaseStateStatus.failed));
    }
  }

  Future<void> _onSearchUser(Emitter<ChatState> emit, String username) async {
    if (username.isEmpty) {
      emit(state.copyWith(searchResults: []));
      return;
    }
    final resp = await _repo.searchUserByUsername(username);
    resp.fold(
      (l) => emit(state.copyWith(searchResults: [])),
      (users) => emit(state.copyWith(searchResults: users)),
    );
  }

  Future<void> _onClearSearch(Emitter<ChatState> emit) async {
    emit(state.copyWith(searchResults: []));
  }
}
