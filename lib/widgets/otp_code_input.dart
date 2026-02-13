import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Telegram-style 6-digit OTP input: one box per digit, auto-advance, paste support.
class OtpCodeInput extends StatefulWidget {
  /// Called whenever the code string changes (e.g. for parent to store and validate).
  final ValueChanged<String> onChanged;
  /// Called when all 6 digits are entered.
  final ValueChanged<String>? onCompleted;

  const OtpCodeInput({
    super.key,
    required this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<OtpCodeInput> {
  static const int _length = 6;
  final List<TextEditingController> _controllers = List.generate(_length, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(_length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String _getCode() => _controllers.map((c) => c.text).join();

  void _notifyChange() {
    final code = _getCode();
    widget.onChanged(code);
    if (code.length == _length) widget.onCompleted?.call(code);
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      _handlePaste(index, value);
      return;
    }
    if (value.isNotEmpty) {
      _controllers[index].text = value[value.length - 1];
      _controllers[index].selection = TextSelection.collapsed(offset: 1);
      if (index < _length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
    _notifyChange();
  }

  void _handlePaste(int startIndex, String pasted) {
    final digits = pasted.replaceAll(RegExp(r'\D'), '').split('').take(_length).toList();
    for (var i = 0; i < digits.length && i < _length; i++) {
      _controllers[i].text = digits[i];
    }
    if (digits.length >= _length) {
      _focusNodes[_length - 1].requestFocus();
    } else {
      _focusNodes[digits.length].requestFocus();
    }
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_length, (index) {
        return SizedBox(
          width: 44,
          child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.error),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
                _PasteAwareFormatter(
                  onPaste: (text) => _handlePaste(index, text),
                ),
              ],
              onChanged: (value) => _onChanged(index, value),
            ),
        );
      }),
    );
  }
}

/// Allows detecting paste and passing full pasted string to handler (other formatters run first).
class _PasteAwareFormatter extends TextInputFormatter {
  final void Function(String) onPaste;

  _PasteAwareFormatter({required this.onPaste});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > 1) {
      onPaste(newValue.text);
      final digit = newValue.text.replaceAll(RegExp(r'\D'), '').isNotEmpty
          ? newValue.text.replaceAll(RegExp(r'\D'), '')[0]
          : '';
      return TextEditingValue(
        text: digit,
        selection: TextSelection.collapsed(offset: digit.length),
      );
    }
    return newValue;
  }
}
