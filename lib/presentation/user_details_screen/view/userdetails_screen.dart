import 'package:employee/core/constants/colors.dart';
import 'package:employee/core/constants/text_styles.dart';
import 'package:employee/core/utils/app_utils.dart';
import 'package:employee/presentation/home_screen/controller/home_screen_controller.dart';
import 'package:employee/repository/api/common/model/employee_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDetails();
    });
  }

  Future<void> _loadUserDetails() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final fetchedUser = await userController.fetchUserDetails(widget.userId);
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          if (userController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60.h,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Employee details not found',
                    style: AppTextStyles.input,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.cardBackground,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240.h,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30.h),
                        Hero(
                          tag: 'user-avatar-${user!.id}',
                          child: Container(
                            height: 120.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.cardBackground,
                                width: 4.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60.r,
                              backgroundImage: NetworkImage(user!.image),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          '${user!.firstName} ${user!.lastName}',
                          style: AppTextStyles.heading,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user!.company.title,
                          style: AppTextStyles.button,
                        ),
                      ],
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.inputBackground,
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: AppColors.inputBackground),
                    onPressed: () => _showEditDialog(context),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildQuickInfoCard(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: user!.email,
                            iconColor: AppColors.primary,
                          ),
                          SizedBox(width: 12.w),
                          _buildQuickInfoCard(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: user!.phone,
                            iconColor: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                    _buildInfoSection(
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                      children: [
                        _buildInfoRow('Gender', user!.gender),
                        _buildInfoRow('Age', user!.age.toString()),
                        _buildInfoRow('Birth Date', user!.birthDate),
                        _buildInfoRow('Blood Group', user!.bloodGroup),
                        _buildInfoRow('Height', '${user!.height} cm'),
                        _buildInfoRow('Weight', '${user!.weight} kg'),
                        _buildInfoRow('Eye Color', user!.eyeColor),
                        _buildInfoRow(
                            'Hair', '${user!.hair.color} ${user!.hair.type}'),
                      ],
                    ),
                    _buildInfoSection(
                      title: 'Address',
                      icon: Icons.location_on_outlined,
                      children: [
                        _buildInfoRow('Street', user!.address.address),
                        _buildInfoRow('City', user!.address.city),
                        _buildInfoRow('State', user!.address.state),
                        _buildInfoRow('Postal Code', user!.address.postalCode),
                        _buildInfoRow('Country', user!.address.country),
                      ],
                    ),
                    _buildInfoSection(
                      title: 'Company',
                      icon: Icons.business_outlined,
                      children: [
                        _buildInfoRow('Name', user!.company.name),
                        _buildInfoRow('Department', user!.company.department),
                        _buildInfoRow('Title', user!.company.title),
                        _buildInfoRow('Address', user!.company.address.address),
                        _buildInfoRow('City', user!.company.address.city),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  title,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: AppTextStyles.label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: AppTextStyles.input,
                ),
              ],
            ),
          ),
          Divider(height: 1.h),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(label, style: AppTextStyles.label),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.label),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final firstNameController = TextEditingController(text: user!.firstName);
    final lastNameController = TextEditingController(text: user!.lastName);
    final phoneController = TextEditingController(text: user!.phone);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.edit, color: AppColors.primary, size: 24.sp),
              SizedBox(width: 8.w),
              const Text('Edit Employee'),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2.w),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2.w),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            Consumer<UserController>(
              builder: (context, userController, child) {
                return ElevatedButton(
                  onPressed: userController.isUpdating
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            final result =
                                await userController.updateUserDetails(
                              widget.userId,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              phone: phoneController.text,
                            );

                            if (result) {
                              Navigator.pop(context);
                              AppUtils.showToast(
                                'Employee updated successfully',
                                context: context,
                              );
                              setState(() {
                                user = userController.selectedUser;
                              });
                            } else {
                              Navigator.pop(context);
                              AppUtils.showToast(
                                'Failed to update employee',
                                context: context,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  ),
                  child: userController.isUpdating
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Update'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
