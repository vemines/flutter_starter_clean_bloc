import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')); // Default Language

  void changeLocale(Locale newLocale) {
    emit(newLocale);
  }
}
