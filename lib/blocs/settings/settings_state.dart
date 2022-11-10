part of 'settings_bloc.dart';

abstract class SettingsState {
  SettingsState({
    this.currency,
    this.language,
    this.onboardingCompleted
  });

  final String currency;
  final String language;
  final bool onboardingCompleted;
}

class InitialSettingsState implements SettingsState {
  final String currency = 'UAH';
  final String language = 'ru';
  final bool onboardingCompleted = false;
}

class LoadedSettingsState implements SettingsState {
  LoadedSettingsState({this.currency, this.language, this.onboardingCompleted});

  final String currency;
  final String language;
  final bool onboardingCompleted;
}
