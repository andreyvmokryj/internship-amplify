import 'dart:ui';

import 'package:meta/meta.dart';

class ChartSection {
  final String categoryName;
  double percents;
  Color color;

  ChartSection({@required this.categoryName, this.percents, this.color});
}
