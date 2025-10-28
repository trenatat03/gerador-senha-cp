import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResultWidget extends StatefulWidget {
  final String password;
  final VoidCallback onCopy;

  const PasswordResultWidget({
    super.key,
    required this.password,
    required this.onCopy,
  });

  @override
  State<PasswordResultWidget> createState() => _PasswordResultWidgetState();
}

class _PasswordResultWidgetState extends State<PasswordResultWidget> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Senha Gerada',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.password == 'Senha não informada'
                      ? widget.password
                      : _isPasswordVisible
                          ? widget.password
                          : '•' * widget.password.length,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: widget.password == 'Senha não informada'
                        ? Colors.grey.shade400
                        : const Color(0xFF7C3AED),
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (widget.password != 'Senha não informada') ...[
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.password));
                    widget.onCopy();
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
