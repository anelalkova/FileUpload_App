part of 'landing_page_bloc.dart';

class LandingPageState extends Equatable{
  final int tabIndex;

  const LandingPageState({this.tabIndex = 0});

  LandingPageState copyWith({
    int? tabIndex,
  }) {
    return LandingPageState(
      tabIndex: tabIndex?? this.tabIndex,
    );
  }

  @override
  List<Object?> get props => [
    tabIndex,
  ];
}

class LandingPageInitial extends LandingPageState{
  const LandingPageInitial({super.tabIndex});
}