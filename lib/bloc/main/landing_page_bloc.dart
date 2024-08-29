import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'landing_page_event.dart';
part 'landing_page_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc() : super(const LandingPageInitial(tabIndex: 0)) {
    on<TabChange>(tabChange);
    on<ReturnLandingInitialState>(returnLandingPageState);
  }

  Future<void> tabChange(TabChange event,
      Emitter<LandingPageState> emit) async {
    emit(state.copyWith(tabIndex: event.tabIndex));
  }

  void returnLandingPageState(ReturnLandingInitialState event,
      Emitter<LandingPageState> emit) {
    emit(LandingPageInitial());
  }
}