import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final String? prefix;
  final TextStyle? style;
  final bool showFrom;

  const PriceWidget({
    super.key,
    required this.price,
    this.prefix,
    this.style,
    this.showFrom = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: prefix ?? '¥', decimalDigits: 0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          showFrom ? '${formatter.format(price)}起' : formatter.format(price),
          style: style ?? const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE53935), // Red price color like Chinese apps
          ),
        ),
      ],
    );
  }
}



