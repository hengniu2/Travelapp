import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

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
    final fromSuffix = showFrom ? (AppLocalizations.of(context)?.priceFrom ?? 'from') : null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            fromSuffix != null ? '${formatter.format(price)}$fromSuffix' : formatter.format(price),
            style: style ?? const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE53935), // Red price color like Chinese apps
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}



