import 'dart:developer';

import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType} $event');
  }

  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('On Change: ${bloc.runtimeType} -> $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('On Error: ${bloc.runtimeType} -> $error', stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }
}
