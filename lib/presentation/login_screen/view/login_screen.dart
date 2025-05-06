
import 'package:employee/core/constants/colors.dart';
import 'package:employee/core/constants/text_styles.dart';
import 'package:employee/presentation/login_screen/controller/login_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.text = "eve.holt@reqres.in";
    _passwordController.text = "cityslicka";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginController(),
      child: Consumer<LoginController>(
        builder: (context, loginController, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Card(
                      color: AppColors.background,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        side: BorderSide(
                          color: AppColors.primary,
                          width: 2.w,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.r),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 80.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                margin: EdgeInsets.only(bottom: 24.h),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.business,
                                  size: 40.sp,
                                  color: AppColors.cardBackground,
                                ),
                              ),
                              Text(
                                "Employee Management",
                                style: AppTextStyles.heading,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 36.h),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  //labelText: "Email",
                                  labelStyle: AppTextStyles.label,
                                  prefixIcon: Container(
                                    margin: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.email,
                                      size: 10.sp,
                                      color: AppColors.cardBackground,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.inputBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE1E5EA),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 2.w,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 16.w,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: AppTextStyles.bodySmall,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: loginController.visibility,
                                decoration: InputDecoration(
                                  //labelText: "Password",
                                  labelStyle: AppTextStyles.label,
                                  prefixIcon: Container(
                                    margin: EdgeInsets.all(8.r),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lock,
                                      size: 10.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      loginController.visibility
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.textHint,
                                      size: 10.sp,
                                    ),
                                    onPressed: () {
                                      loginController
                                          .togglePasswordVisibility();
                                    },
                                  ),
                                  filled: true,
                                  fillColor: AppColors.inputBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: const BorderSide(
                                        color: AppColors.inputBackground),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 2.w,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 16.w,
                                  ),
                                ),
                                style: AppTextStyles.input,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 36.h),
                              SizedBox(
                                height: 56.h,
                                child: ElevatedButton(
                                  onPressed: loginController.isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            loginController.onLogin(
                                              _emailController.text,
                                              _passwordController.text,
                                              context,
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.cardBackground,
                                    backgroundColor: AppColors.primary,
                                    disabledBackgroundColor:
                                         AppColors.primary
                                            .withOpacity(0.6),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: loginController.isLoading
                                      ? SizedBox(
                                          height: 24.h,
                                          width: 24.h,
                                          child:
                                              const CircularProgressIndicator(
                                            color: AppColors.cardBackground,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : Text(
                                          "Login",
                                          style: AppTextStyles.button,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
