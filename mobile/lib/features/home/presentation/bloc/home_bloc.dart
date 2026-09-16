import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

export 'home_event.dart';
export 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeInitial()) {
    on<HomeFetchStarted>(_onFetchStarted);
    on<HomeRefreshed>(_onRefreshed);
  }

  Future<void> _onFetchStarted(
    HomeFetchStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    await _loadData(emit);
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<HomeState> emit) async {
    try {
      final data = await _homeRepository.getHomeData();
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeFailure(_mapError(e)));
    }
  }

  String _mapError(dynamic e) {
    final str = e.toString();
    if (str.contains('SocketException') || str.contains('Connection refused') || str.contains('Failed host lookup')) {
      return 'Không thể kết nối máy chủ.';
    }
    return str.replaceAll('Exception: ', '');
  }
}
