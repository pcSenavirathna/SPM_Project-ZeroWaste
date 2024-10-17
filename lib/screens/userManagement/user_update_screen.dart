import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/providers/user_provider.dart';
import 'package:zero_waste/repositories/employee_repository.dart';
import 'package:zero_waste/repositories/household_user_repository.dart';
import 'package:zero_waste/utils/user_types.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/select_dropdown.dart';
import 'package:zero_waste/widgets/submit_button.dart';
import 'package:zero_waste/widgets/text_field_input.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserUpdateScreen extends StatefulWidget {
  const UserUpdateScreen({super.key});

  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  late User loginedUser;
  late HouseholdUser? householdUser;
  late Employee? employee;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final _mobileNoController = TextEditingController();
  final _addressController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _noOfHouseholds;
  File? _selectedImage;
  String? _imageUrl;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    getLoginedUser();
  }

  void getLoginedUser() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    loginedUser = userProvider.user!;
    if (loginedUser.userType == UserTypes.HOUSEHOLD_USER) {
      HouseholdUserRepository()
          .getHouseholdUserByUserId(loginedUser.id)
          .then((fetchedUser) {
        if (fetchedUser != null) {
          setState(() {
            householdUser = fetchedUser;
            employee = null;
            isLoading = false;
            _mobileNoController.text = householdUser!.mobile;
            _addressController.text = householdUser!.address;
            _noOfHouseholds = householdUser!.households;
            _imageUrl = householdUser!.imageUrl;
          });
        }
      }).catchError((error) {
        okMessageDialog(context, "Failed!", error.toString());
      });
    } else if (loginedUser.userType == UserTypes.EMPLOYEE) {
      EmployeeRepository()
          .getEmployeeByUserId(loginedUser.id)
          .then((fetchedUser) {
        if (fetchedUser != null) {
          setState(() {
            employee = fetchedUser;
            householdUser = null;
            isLoading = false;
            _mobileNoController.text = employee!.mobile;
            _addressController.text = employee!.address;
            _imageUrl = employee!.imageUrl;
          });
        }
      }).catchError((error) {
        okMessageDialog(context, "Failed!", error.toString());
      });
    }
  }

  ImageProvider<Object> displayImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (_imageUrl != null) {
      return NetworkImage(_imageUrl!) as ImageProvider;
    } else {
      return const NetworkImage('https://via.placeholder.com/150')
          as ImageProvider;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        final String fileName =
            'users/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final UploadTask uploadTask =
            _storage.ref(fileName).putFile(_selectedImage!);
        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _uploadedImageUrl = downloadUrl;
        });

        print('Image uploaded: $downloadUrl');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl;

        if (_selectedImage != null) {
          await _uploadImage();
          imageUrl = _uploadedImageUrl;
        }

        if (loginedUser.userType == UserTypes.HOUSEHOLD_USER) {
          HouseholdUser updatedUser = householdUser!;
          updatedUser.mobile = _mobileNoController.text;
          updatedUser.address = _addressController.text;
          updatedUser.households = _noOfHouseholds!;

          if (imageUrl != null) {
            updatedUser.imageUrl = imageUrl;
          }
          await HouseholdUserRepository()
              .updateUser(householdUser!.id, updatedUser);
          okMessageDialog(
              context, "Success!", "HouseholdUser Updated Successfully");
          context.go("/profile");
        } else if (loginedUser.userType == UserTypes.EMPLOYEE) {
          Employee updatedEmployee = employee!;
          updatedEmployee.mobile = _mobileNoController.text;
          updatedEmployee.address = _addressController.text;

          if (imageUrl != null) {
            updatedEmployee.imageUrl = imageUrl;
          }
          await EmployeeRepository()
              .updateEmployee(employee!.id, updatedEmployee);
          okMessageDialog(context, "Success!", "Employee Updated Successfully");
          context.go("/profile");
        }
      } catch (error, stack) {
        okMessageDialog(context, "Failed!", error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_back),
                                                  onPressed: () {
                                                    context.go('/profile');
                                                  },
                                                ),
                                              ],
                                            ),
                                            Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 80,
                                                  backgroundImage:
                                                      displayImage(),
                                                ),
                                                Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.green),
                                                      onPressed: _pickImage,
                                                    )),
                                              ],
                                            ),
                                          ]))),
                              const SizedBox(height: 16),
                              Column(
                                children: [
                                  TextFieldInput(
                                      title: "Contact Number",
                                      icon: Icons.person,
                                      controller: _mobileNoController,
                                      inputType: TextInputType.number,
                                      validator: Validators.validateMobile),
                                  const SizedBox(height: 16),
                                  TextFieldInput(
                                      title: "Address",
                                      icon: Icons.person,
                                      controller: _addressController,
                                      inputType: TextInputType.text,
                                      validator: Validators.nullCheck),
                                  SizedBox(
                                      height: loginedUser.userType ==
                                              UserTypes.HOUSEHOLD_USER
                                          ? 16
                                          : 0),
                                  loginedUser.userType ==
                                          UserTypes.HOUSEHOLD_USER
                                      ? SelectDropdown(
                                          title: "No of Households",
                                          items: const [
                                            '1',
                                            '2',
                                            '3',
                                            '4',
                                            '5',
                                            '6',
                                            '7',
                                            '8',
                                            '9',
                                            '10'
                                          ],
                                          selectedValue: _noOfHouseholds,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _noOfHouseholds = newValue;
                                            });
                                          },
                                          hint: "Select Item")
                                      : const SizedBox(height: 0),
                                  const SizedBox(height: 24),
                                  SubmitButton(
                                      icon: Icons.send,
                                      text: "Update",
                                      whenPressed: _submitForm),
                                ],
                              )
                            ],
                          ))),
            ],
          ),
        ),
      ),
    );
  }
}
