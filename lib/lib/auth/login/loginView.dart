import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/lib/auth/login/login_bloc.dart';
import 'package:my_spend/lib/auth/login/login_events.dart';
import 'package:my_spend/lib/auth/login/login_states.dart';
import 'package:my_spend/routes/routesName.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Loginview extends StatelessWidget {
  const Loginview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.postApiStatus != current.postApiStatus,
          listener: (context, state) {
            if (state.postApiStatus == PostApiStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.Error,
                ),
              );
            }
            if (state.postApiStatus == PostApiStatus.completed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login successful! Welcome back."),
                  backgroundColor: AppColors.Success,
                ),
              );
              context.goNamed(Routesname.dashBoard);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.ph,
                Text("Welcome back", style: AppTextStyles.headingLarge),
                10.ph,
                Text(
                  "Sign in to continue",
                  style: AppTextStyles.bodyMuted,
                ),
                30.ph,
                Text("Email", style: AppTextStyles.bodyMuted),
                10.ph,
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.email != current.email,
                  builder: (context, state) {
                    return CustomFormField(
                      focusNode: _emailFocusNode,
                      hint: "you@example.com",
                      onChanged: (value) {
                        context.read<LoginBloc>().add(
                              EmailChangedEvent(email: value),
                            );
                      },
                    );
                  },
                ),
                20.ph,
                Text("Password", style: AppTextStyles.bodyMuted),
                10.ph,
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.password != current.password ||
                      previous.showPassword != current.showPassword,
                  builder: (context, state) {
                    return CustomFormField(
                      focusNode: _passwordFocusNode,
                      obscureText: state.showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () {
                          context
                              .read<LoginBloc>()
                              .add(const PasswordVisibilityEvents());
                        },
                      ),
                      hint: "******",
                      onChanged: (value) {
                        context.read<LoginBloc>().add(
                              PasswordChangedEvent(password: value),
                            );
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot?",
                      style: AppTextStyles.bodyMuted.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                30.ph,
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.postApiStatus != current.postApiStatus,
                  builder: (context, state) {
                    final isLoading =
                        state.postApiStatus == PostApiStatus.loading;
                    return CustomButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context
                                  .read<LoginBloc>()
                                  .add(const LoginSubmittedEvent());
                            },
                      title: isLoading ? "Signing In..." : "Sign In",
                    );
                  },
                ),
                20.ph,
                Align(
                  alignment: Alignment.center,
                  child: Text("or continue with", style: AppTextStyles.captionBold),
                ),
                15.ph,
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Google",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                20.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.headingSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(Routesname.signup);
                      },
                      child: Text(
                        "Sign Up",
                        style: AppTextStyles.headingSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
