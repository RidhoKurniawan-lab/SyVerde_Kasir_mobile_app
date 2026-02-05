import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/auth/login_form.dart';
import 'package:frontend/core/constants/app_color.dart';

class LoginScreen extends StatefulWidget {
  final String? message;

  const LoginScreen({
    super.key,
    this.message
    });
  @override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

@override
  void initState() {
    super.initState();

    // Pastikan widget sudah build sebelum menampilkan toast
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.message != null && widget.message!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.message!),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen =
        MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.primary,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight, 
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          if (!isKeyboardOpen) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 56),
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 150,
                              ),
                            ),
                            const SizedBox(height: 56),
                          ],

                          Expanded(child: LoginForm()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}