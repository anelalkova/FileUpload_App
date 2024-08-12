part of 'landing_page_bloc.dart';

class LandingPageEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class TabChange extends LandingPageEvent{
  final int tabIndex;

  TabChange({required this.tabIndex});
}