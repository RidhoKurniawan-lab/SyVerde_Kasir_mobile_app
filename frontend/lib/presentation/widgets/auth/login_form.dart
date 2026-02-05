import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/widgets/common/custom_text_field.dart';
import 'package:frontend/presentation/widgets/common/primary_button.dart';
import 'package:frontend/state/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final ProviderSubscription _authSub;

  @override
  void initState() {
    super.initState();

    _authSub = ref.listenManual<AuthState>(authProvider, (prev, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message)));
      }
      if (next is AuthSuccess) {
        if (next.user.role!.name == 'Administrator') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (next.user.role!.name == 'Cashier') {
          Navigator.pushReplacementNamed(context, '/kasir');
        }
      }
    });
  }

  @override
  void dispose() {
    _authSub.close();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.primarywhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(46),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const SizedBox(height: 50),

              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
              ),

              Text(
                'Please login to your account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.primary.withOpacity(0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: 333,
            child: CustomTextField(
              withicon: true,
              controller: _emailController,
              label: 'Email',
              hintText: 'Masukkan email',
              prefixIcon: Icons.email_outlined,
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: 333,
            child: CustomTextField(
              withicon: true,
              controller: _passwordController,
              label: 'Password',
              hintText: 'Masukkan password',
              prefixIcon: Icons.lock_outlined,
              obscureText: true,
            ),
          ),

          const SizedBox(height: 50),

          SizedBox(
            width: 333,
            child: PrimaryButton(
              text: authState is AuthLoading ? 'Loading...' : 'Login',
              backgroundColor: AppColor.primary,
              onPressed: authState is AuthLoading
                  ? null
                  : () {
                      ref
                          .read(authProvider.notifier)
                          .login(
                            _emailController.text,
                            _passwordController.text,
                          );
                    },
            ),
          ),
        ],
      ),
    );
  }
}
