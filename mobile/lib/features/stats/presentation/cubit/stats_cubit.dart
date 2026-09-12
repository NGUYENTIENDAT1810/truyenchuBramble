import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/stats_repository.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {
  const StatsInitial();
}

class StatsLoading extends StatsState {
  const StatsLoading();
}

class StatsLoaded extends StatsState {
  final Map<String, dynamic> data;

  const StatsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class StatsFailure extends StatsState {
  final String message;

  const StatsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class StatsCubit extends Cubit<StatsState> {
  final StatsRepository _statsRepository;

  StatsCubit({required StatsRepository statsRepository})
      : _statsRepository = statsRepository,
        super(const StatsInitial());

  Future<void> loadStats() async {
    emit(const StatsLoading());
    try {
      final data = await _statsRepository.getUserStats();
      emit(StatsLoaded(data));
    } catch (e) {
      emit(StatsFailure(e.toString()));
    }
  }

  Future<void> refresh() async {
    try {
      final data = await _statsRepository.getUserStats();
      emit(StatsLoaded(data));
    } catch (e) {
      emit(StatsFailure(e.toString()));
    }
  }
}
