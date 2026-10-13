import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/lib/home/profile/personal_info/bloc/personal_info_bloc.dart';
import 'package:my_spend/lib/home/profile/personal_info/bloc/personal_info_event.dart';
import 'package:my_spend/lib/home/profile/personal_info/bloc/personal_info_state.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../../utils/extensions/sizedboxext.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PersonalInfoBloc()..add(const LoadPersonalInfoEvent()),
      child: const _PersonalInfoContent(),
    );
  }
}

class _PersonalInfoContent extends StatefulWidget {
  const _PersonalInfoContent();

  @override
  State<_PersonalInfoContent> createState() => _PersonalInfoContentState();
}

class _PersonalInfoContentState extends State<_PersonalInfoContent> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && context.mounted) {
      context
          .read<PersonalInfoBloc>()
          .add(ImagePickedEvent(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<PersonalInfoBloc, PersonalInfoState>(
          listenWhen: (previous, current) =>
              previous.postApiStatus != current.postApiStatus ||
              previous.status != current.status,
          listener: (context, state) {
            if (state.status == Status.completed) {
              if (_nameController.text.isEmpty) {
                _nameController.text = state.name;
              }
              if (_emailController.text.isEmpty) {
                _emailController.text = state.email;
              }
            }

            if (state.postApiStatus == PostApiStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.Error,
                ),
              );
            } else if (state.postApiStatus == PostApiStatus.completed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message.isEmpty
                      ? "Personal Information Saved!"
                      : state.message),
                  backgroundColor: AppColors.Success,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Personal Information", style: AppTextStyles.headingLarge),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                25.ph,
                BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                  builder: (context, state) {
                    return Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: state.imageFile != null
                                ? FileImage(state.imageFile!)
                                : (state.photoUrl != null
                                    ? NetworkImage(state.photoUrl!) as ImageProvider
                                    : null),
                            child: (state.imageFile == null && state.photoUrl == null)
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _pickImage(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                30.ph,
                Text("Full Name", style: AppTextStyles.captionBold),
                10.ph,
                CustomFormField(
                  controller: _nameController,
                  hint: "Manish Yadav",
                ),
                20.ph,
                Text("Email (Read Only)", style: AppTextStyles.captionBold),
                10.ph,
                CustomFormField(
                  controller: _emailController,
                  readOnly: true,
                  hint: "user@example.com",
                ),
                40.ph,
                BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                  buildWhen: (previous, current) =>
                      previous.postApiStatus != current.postApiStatus,
                  builder: (context, state) {
                    final isLoading =
                        state.postApiStatus == PostApiStatus.loading;
                    return CustomButton(
                      title: isLoading ? "Saving..." : "Save Profile",
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<PersonalInfoBloc>().add(
                                    SavePersonalInfoSubmittedEvent(
                                      name: _nameController.text.trim(),
                                    ),
                                  );
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
