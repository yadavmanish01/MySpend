import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/lib/auth/signup/signup_bloc.dart';
import 'package:my_spend/routes/routesName.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: const _SignupBody(),
    );
  }
}

class _SignupBody extends StatefulWidget {
  const _SignupBody();

  @override
  State<_SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<_SignupBody> {
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SignupBloc, SignupState>(
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
                  content: Text("Account created successfully! Welcome."),
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
                Text("Create Account", style: AppTextStyles.headingLarge),
                10.ph,
                Text(
                  "Sign up to start managing your spendings",
                  style: AppTextStyles.bodyMuted,
                ),
                25.ph,
                Text("Full Name", style: AppTextStyles.bodyMuted),
                10.ph,
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.name != current.name,
                  builder: (context, state) {
                    return CustomFormField(
                      focusNode: _nameFocusNode,
                      hint: "John Doe",
                      onChanged: (value) {
                        context
                            .read<SignupBloc>()
                            .add(NameChangedEvent(name: value));
                      },
                    );
                  },
                ),
                20.ph,
                Text("Email", style: AppTextStyles.bodyMuted),
                10.ph,
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.email != current.email,
                  builder: (context, state) {
                    return CustomFormField(
                      focusNode: _emailFocusNode,
                      hint: "you@example.com",
                      onChanged: (value) {
                        context
                            .read<SignupBloc>()
                            .add(EmailChangedEvent(email: value));
                      },
                    );
                  },
                ),
                20.ph,
                Text("Password", style: AppTextStyles.bodyMuted),
                10.ph,
                BlocBuilder<SignupBloc, SignupState>(
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
                              .read<SignupBloc>()
                              .add(const PasswordVisibilityEvent());
                        },
                      ),
                      hint: "******",
                      onChanged: (value) {
                        context
                            .read<SignupBloc>()
                            .add(PasswordChangedEvent(password: value));
                      },
                    );
                  },
                ),
                35.ph,
                BlocBuilder<SignupBloc, SignupState>(
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
                                  .read<SignupBloc>()
                                  .add(const SignupSubmittedEvent());
                            },
                      title: isLoading ? "Creating Account..." : "Sign Up",
                    );
                  },
                ),
                20.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyles.headingSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(Routesname.login);
                      },
                      child: Text(
                        "Sign In",
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
