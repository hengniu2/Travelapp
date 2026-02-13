import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Country/region with dial code for phone input. [flagEmoji] from ISO code (e.g. CN → 🇨🇳).
class CountryCode {
  final String name;
  final String code;
  final String dialCode;

  const CountryCode({required this.name, required this.code, required this.dialCode});

  /// Regional indicator symbols for flag emoji (e.g. CN → 🇨🇳).
  String get flagEmoji {
    if (code.length != 2) return '';
    final a = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final b = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCodes([a, b]);
  }

  String get fullDisplay => '$name (+$dialCode)';
}

/// Predefined list. China first (customer app).
const List<CountryCode> kCountryCodes = [
  CountryCode(name: 'China', code: 'CN', dialCode: '86'),
  CountryCode(name: 'United States', code: 'US', dialCode: '1'),
  CountryCode(name: 'United Kingdom', code: 'GB', dialCode: '44'),
  CountryCode(name: 'Japan', code: 'JP', dialCode: '81'),
  CountryCode(name: 'South Korea', code: 'KR', dialCode: '82'),
  CountryCode(name: 'Singapore', code: 'SG', dialCode: '65'),
  CountryCode(name: 'Hong Kong', code: 'HK', dialCode: '852'),
  CountryCode(name: 'Taiwan', code: 'TW', dialCode: '886'),
  CountryCode(name: 'Australia', code: 'AU', dialCode: '61'),
  CountryCode(name: 'Germany', code: 'DE', dialCode: '49'),
  CountryCode(name: 'France', code: 'FR', dialCode: '33'),
  CountryCode(name: 'India', code: 'IN', dialCode: '91'),
];

/// Localized country name from l10n (standard Chinese when locale is zh).
String countryDisplayName(CountryCode c, AppLocalizations l10n) {
  switch (c.code) {
    case 'CN': return l10n.countryChina;
    case 'US': return l10n.countryUSA;
    case 'GB': return l10n.countryUK;
    case 'JP': return l10n.countryJapan;
    case 'KR': return l10n.countryKorea;
    case 'SG': return l10n.countrySingapore;
    case 'HK': return l10n.countryHongKong;
    case 'TW': return l10n.countryTaiwan;
    case 'AU': return l10n.countryAustralia;
    case 'DE': return l10n.countryGermany;
    case 'FR': return l10n.countryFrance;
    case 'IN': return l10n.countryIndia;
    default: return c.name;
  }
}

/// Phone input row: country dropdown (flag + name + code) + number field. Full number = dialCode + number.
class CountryCodePhoneInput extends StatelessWidget {
  final CountryCode selectedCountry;
  final ValueChanged<CountryCode> onCountryChanged;
  final TextEditingController numberController;
  final AppLocalizations l10n;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;

  const CountryCodePhoneInput({
    super.key,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.numberController,
    required this.l10n,
    this.labelText,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          height: 56,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CountryCode>(
                value: selectedCountry,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, size: 26),
                items: kCountryCodes.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Center(
                      child: Text(
                        '${c.flagEmoji} ${countryDisplayName(c, l10n)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (c) {
                  if (c != null) onCountryChanged(c);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: numberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText ?? (selectedCountry.code == 'CN' ? '13800138000' : ''),
              prefixText: '+${selectedCountry.dialCode} ',
              prefixStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
