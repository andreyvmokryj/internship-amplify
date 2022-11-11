import 'dart:ui';

import 'package:meta/meta.dart';

class ChartCategoryDetails {
  final String categoryName;
  double percents;
  double value;
  Color color;

  ChartCategoryDetails({@required this.categoryName, this.percents, this.value, this.color});
}