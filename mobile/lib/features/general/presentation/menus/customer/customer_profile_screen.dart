import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/user_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final fullNameController = ref.watch(fullNameControllerProvider);

    final user = ref.watch(userProvider);
    final emailController = ref.watch(emailControllerProvider);

    if (user != null && fullNameController.text.isEmpty) {
      fullNameController.text = user.fullName;
    }
    if (user != null && emailController.text.isEmpty) {
      emailController.text = user.email;
    }

    void onHandleEditDetailsSubmit(
      GlobalKey<FormState> formKey,
      BuildContext context,
      TextEditingController fullNameController,
      TextEditingController emailController,
      WidgetRef ref,
    ) {
      if (!formKey.currentState!.validate()) {
        ToastUtil.showErrorToast(context, "Please fill in all fields");
        return;
      }
      ref.read(loadingProvider.notifier).state = true;
      ref
          .read(userProvider.notifier)
          .setUser(emailController.text, fullNameController.text, null);
      ref.read(loadingProvider.notifier).state = false;
      ToastUtil.showSuccessToast(context, "Saved successfully");
      context.pop();
    }

    return NestScaffold(
      showBackButton: true,
      title: 'personal details',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NestForm(
              formKey: formKey,
              spacing: 1,
              fields: [
                NestFormField(
                  belowSpacing: false,
                  controller: fullNameController,
                  hintText: "Enter full name",
                  label: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                NestFormField(
                  controller: emailController,
                  readOnly: true,
                  label: "Email address",
                ),
              ],
              onSubmit:
                  () => onHandleEditDetailsSubmit(
                    formKey,
                    context,
                    fullNameController,
                    emailController,
                    ref,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
