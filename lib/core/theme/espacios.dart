import 'package:flutter/material.dart';

abstract final class Espacios {
  static const double e0 = 0;
  static const double e4 = 4;
  static const double e8 = 8;
  static const double e12 = 12;
  static const double e16 = 16;
  static const double e20 = 20;
  static const double e24 = 24;
  static const double e32 = 32;
  static const double e40 = 40;
  static const double e48 = 48;

  static const double margenPantalla = 16;

  static const double botonM = 40;
  static const double botonL = 56;
}

abstract final class Radios {
  static const double extraSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double extraLarge = 28;
  static const double full = 999;

  static const BorderRadius brExtraSmall = BorderRadius.all(
    Radius.circular(extraSmall),
  );
  static const BorderRadius brSmall = BorderRadius.all(Radius.circular(small));
  static const BorderRadius brMedium = BorderRadius.all(
    Radius.circular(medium),
  );
  static const BorderRadius brLarge = BorderRadius.all(Radius.circular(large));
  static const BorderRadius brExtraLarge = BorderRadius.all(
    Radius.circular(extraLarge),
  );
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));
}
