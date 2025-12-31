import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/auth/login_form.dart';
import 'package:frontend/core/constants/app_color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  

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
