import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeFetchStarted extends HomeEvent {
  const HomeFetchStarted();
}

class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}
