import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/repositories/employee_repository.dart';
import 'package:zero_waste/repositories/household_user_repository.dart';
import 'package:zero_waste/utils/user_types.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/date_picker.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/select_dropdown.dart';
import 'package:zero_waste/widgets/text_field_input.dart';
import '../../widgets/submit_button.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _nicController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _employeeType;
  DateTime dob = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
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
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldInput(
                      title: 'First Name',
                      icon: Icons.person,
                      controller: _fnameController,
                      inputType: TextInputType.text,
                      validator: Validators.nullCheck,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "Last Name",
                        icon: Icons.person,
                        controller: _lnameController,
                        inputType: TextInputType.text,
                        validator: Validators.nullCheck),
                    const SizedBox(height: 16),
                    AppDatePicker(
                      title: "Date Of Birth",
                      onChangedDate: (value) =>
                      dob = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                        title: "NIC",
                        icon: Icons.person,
                        controller: _nicController,
                        inputType: TextInputType.text,
                        validator: Validators.validateNIC),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    SelectDropdown(
                        title: "Employee Type",
                        items: const [
                          UserTypes.EMPLOYEE,
                          UserTypes.TRUCK_DRIVER
                        ],
                        selectedValue: _employeeType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _employeeType = newValue;
                          });
                        },
                        hint: "Select Item"),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      title: "Email",
                      icon: Icons.person,
                      controller: _emailController,
                      validator: Validators.validateEmail,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFieldInput(
                      title: "Password",
                      icon: Icons.person,
                      controller: _passwordController,
                      inputType: TextInputType.visiblePassword,
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(
                        icon: Icons.person_add,
                        text: "Add Employee",
                        whenPressed: _submitForm),
                  ],
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _emailController.text,
        password: _passwordController.text,
        userType: UserTypes.EMPLOYEE,
      );
      final employee = Employee(
        id: '',
        fName: _fnameController.text,
        lName: _lnameController.text,
        dob: dob,
        nic: _nicController.text,
        mobile: _mobileNoController.text,
        address: _addressController.text,
        employeeType: _employeeType!,
        userId: '',
      );
      EmployeeRepository().addEmployee(user, employee).then((_) {
        okMessageDialog(
            context, "Success!", "Employee Registered Successfully");
        context.go("/profile");
      }).catchError((error, stack) {
        okMessageDialog(context, "Failed!", error.toString());
      });
    }
  }
}
