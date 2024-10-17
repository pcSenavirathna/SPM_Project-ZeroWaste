import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/repositories/household_user_repository.dart';
import 'package:zero_waste/utils/user_types.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/date_picker.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/select_dropdown.dart';
import 'package:zero_waste/widgets/text_field_input.dart';
import '../../widgets/submit_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _nicController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _noOfHouseholds;
  DateTime dob = DateTime.now();

  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  String? _noOfEmployees;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () {
                  context.go('/home');
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 120.0, bottom: 155.0),
                title: const Text(
                  'User Register',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                background: Image.asset(
                  'assets/garbage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                      onChangedDate: (value) => dob = value!,
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
                        icon: Icons.send,
                        text: "Register",
                        whenPressed: _submitForm),
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Already have an account?",
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                          text: "Login",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.orangeAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go("/user/login");
                            })
                    ]))
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    ));
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        email: _emailController.text,
        password: _passwordController.text,
        userType: UserTypes.HOUSEHOLD_USER,
      );
      final householdUser = HouseholdUser(
        id: '',
        fName: _fnameController.text,
        lName: _lnameController.text,
        dob: dob,
        nic: _nicController.text,
        mobile: _mobileNoController.text,
        address: _addressController.text,
        households: _noOfHouseholds!,
        userId: '',
      );
      HouseholdUserRepository().addUser(user, householdUser).then((_) {
        okMessageDialog(
            context, "Success!", "HouseholdUser Registered Successfully");
        context.go('/user/login');
      }).catchError((error, stack) {
        okMessageDialog(context, "Failed!", error.toString());
      });
    }
  }
}
