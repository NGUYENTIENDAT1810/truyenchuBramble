import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/home_repository.dart';
import 'home_state.dart';

export 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeInitial());

  Future<void> fetchStarted() async {
    emit(const HomeLoading());
    await _loadData();
  }

  Future<void> refreshed() async {
    await _loadData();
  }

  Future<void> _loadData() async {
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
