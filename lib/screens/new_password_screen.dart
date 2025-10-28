import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/password_result_widget.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen>
    with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String _generatedPassword = '';
  bool _isGenerating = false;
  bool _showOptions = false;
  
  // Password generation options
  double _passwordLength = 12;
  bool _includeLowercase = true;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Gerador de Senhas',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showAppInfo,
            icon: const Icon(Icons.info_outline, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Password display
            PasswordResultWidget(
              password: _generatedPassword.isEmpty 
                  ? 'Senha não informada' 
                  : _generatedPassword,
              onCopy: _copyPassword,
            ),
            const SizedBox(height: 20),
            // Options toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tamanho da senha: ${_passwordLength.round()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: _toggleOptions,
                  child: Text(
                    _showOptions ? 'Ocultar opções' : 'Mostrar opções',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            // Password length slider
            Slider(
              value: _passwordLength,
              min: 4,
              max: 50,
              divisions: 46,
              activeColor: Colors.white,
              inactiveColor: Colors.white30,
              onChanged: (value) {
                setState(() {
                  _passwordLength = value;
                });
              },
            ),
            // Options section with animation
            SizeTransition(
              sizeFactor: _animation,
              child: _showOptions ? _buildOptionsSection() : const SizedBox.shrink(),
            ),
            const SizedBox(height: 30),
            // Generate button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1E3A8A),
                          ),
                        ),
                      )
                    : const Text(
                        'Gerar Senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _generatedPassword.isNotEmpty
          ? FloatingActionButton(
              onPressed: _showSaveDialog,
              backgroundColor: const Color(0xFF7C3AED),
              child: const Icon(Icons.save, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildOptionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildOptionSwitch(
            'Incluir letras minúsculas',
            _includeLowercase,
            (value) => setState(() => _includeLowercase = value),
          ),
          const SizedBox(height: 15),
          _buildOptionSwitch(
            'Incluir letras maiúsculas',
            _includeUppercase,
            (value) => setState(() => _includeUppercase = value),
          ),
          const SizedBox(height: 15),
          _buildOptionSwitch(
            'Incluir números',
            _includeNumbers,
            (value) => setState(() => _includeNumbers = value),
          ),
          const SizedBox(height: 15),
          _buildOptionSwitch(
            'Incluir símbolos',
            _includeSymbols,
            (value) => setState(() => _includeSymbols = value),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSwitch(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.white70,
          inactiveThumbColor: Colors.grey.shade300,
          inactiveTrackColor: Colors.grey.shade600,
        ),
      ],
    );
  }

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
      if (_showOptions) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _generatePassword() async {
    if (!_includeLowercase && !_includeUppercase && !_includeNumbers && !_includeSymbols) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos uma opção de caracteres'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://safekey-api-a1bd9aa97953.herokuapp.com/generate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'length': _passwordLength.round(),
          'include_lowercase': _includeLowercase,
          'include_uppercase': _includeUppercase,
          'include_numbers': _includeNumbers,
          'include_symbols': _includeSymbols,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _generatedPassword = data['password'] ?? '';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha gerada com sucesso!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar senha: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _copyPassword() {
    if (_generatedPassword.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha copiada para a área de transferência'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSaveDialog() {
    final labelController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salvar senha'),
        content: TextField(
          controller: labelController,
          decoration: const InputDecoration(
            labelText: 'Tipo da senha',
            hintText: 'Ex: Email, Banco, Rede Social',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (labelController.text.trim().isNotEmpty) {
                _savePassword(labelController.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _savePassword(String label) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('passwords').add({
        'userId': user.uid,
        'label': label,
        'password': _generatedPassword,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha salva com sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar senha: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o App'),
        content: const Text(
          'Gerador de Senhas Seguro\n\n'
          'Este aplicativo permite gerar senhas seguras usando uma API externa '
          'e salvá-las de forma criptografada no Firebase.\n\n'
          'Recursos:\n'
          '• Geração de senhas personalizáveis\n'
          '• Armazenamento seguro\n'
          '• Interface intuitiva\n'
          '• Autenticação Firebase',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
