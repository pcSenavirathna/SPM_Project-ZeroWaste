import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBins {
  CustomBins._();

  static const _kFontFam = 'CustomBins';
  static const String? _kFontPkg = null;

  static const IconData wasteBin =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  static Icon getBinIcon(String binType) {
    switch (binType) {
      case 'Plastic':
        return const Icon(
          wasteBin,
          color: Colors.blue,
          size: 56,
        );
      case 'Metal':
        return const Icon(
          wasteBin,
          color: Colors.grey,
          size: 56,
        );
      case 'Paper':
        return const Icon(
          wasteBin,
          color: Colors.yellow,
          size: 56,
        );
      case 'Organic':
        return const Icon(
          wasteBin,
          color: Colors.green,
          size: 56,
        );
      case 'Wood':
        return const Icon(
          wasteBin,
          color: Colors.brown,
          size: 56,
        );
      case 'Medical':
        return const Icon(
          wasteBin,
          color: Colors.purple,
          size: 56,
        );
      case 'E-waste':
        return const Icon(
          wasteBin,
          color: Colors.orange,
          size: 56,
        );
      default:
        return const Icon(
          wasteBin,
          color: Colors.blueGrey,
          size: 56,
        );
    }
  }
}
