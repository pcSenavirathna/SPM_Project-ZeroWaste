import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/collection_route.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/route_schedule.dart';
import 'package:zero_waste/repositories/collection_route_repository.dart';
import 'package:zero_waste/repositories/employee_repository.dart';
import 'package:zero_waste/repositories/route_schedule_repository.dart';
import 'package:zero_waste/utils/user_types.dart';
import 'package:zero_waste/widgets/date_picker.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/select_dropdown.dart';
import 'package:zero_waste/widgets/submit_button.dart';

class AssignRoute extends StatefulWidget {
  const AssignRoute({super.key});

  @override
  State<AssignRoute> createState() => _AssignRouteState();
}

class _AssignRouteState extends State<AssignRoute> {
  final _formKey = GlobalKey<FormState>();
  List<String> routeList = [];
  late List<CollectionRoute> allRoutes;
  List<String> employeeList = [];
  late List<Employee> allEmployees;
  String? _collectionRoute;
  String? _driverId;
  DateTime scheduleDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadRoutes();
    loadDrivers();
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
                  context.go('/profile');
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 120.0, bottom: 155.0),
                title: const Text(
                  'Assign Routes',
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
                    AppDatePicker(
                      title: "Collection Date",
                      onChangedDate: (value) => scheduleDate = value!,
                    ),
                    const SizedBox(height: 16),
                    SelectDropdown(
                        title: "Route",
                        items: routeList,
                        selectedValue: _collectionRoute,
                        onChanged: (String? newValue) {
                          setState(() {
                            _collectionRoute = newValue;
                          });
                        },
                        hint: "Select Route"),
                    const SizedBox(height: 16),
                    SelectDropdown(
                        title: "Assign Driver",
                        items: employeeList,
                        selectedValue: _driverId,
                        onChanged: (String? newValue) {
                          setState(() {
                            _driverId = newValue;
                          });
                        },
                        hint: "Select DriverId"),
                    const SizedBox(height: 24),
                    SubmitButton(
                        icon: Icons.send,
                        text: "Assign Route",
                        whenPressed: _submitForm),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    ));
  }

  void loadRoutes() {
    CollectionRouteRepository().getAllRoutes().then((collectionRoutes) {
      CollectionRoute route;
      List<String> routes = [];
      for (route in collectionRoutes) {
        String routeName =
            '${route.id} - ${route.startLocation} to ${route.endLocation}';
        routes.add(routeName);
      }
      setState(() {
        routeList = routes;
        allRoutes = collectionRoutes;
      });
    }).catchError((error) {
      okMessageDialog(context, 'Failed!', error.toString());
    });
  }

  void loadDrivers() {
    EmployeeRepository().getAllEmployees().then((employees) {
      Employee employee;
      List<String> employeeStringList = [];
      for (employee in employees) {
        print(employee.toMap());
        if (employee.employeeType == UserTypes.TRUCK_DRIVER) {
        print(employee.toMap());
          String emps = '${employee.id} - ${employee.fName}';
        employeeStringList.add(emps);
        }
      }
      setState(() {
        employeeList = employeeStringList;
        allEmployees = employees;
      });
    }).catchError((error) {
      okMessageDialog(context, 'Failed!', error.toString());
    });
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final schedule = RouteSchedule(
        routeId: _collectionRoute!.split(' -')[0],
        scheduleDate: scheduleDate,
        driverId: _driverId!,
      );

      RouteScheduleRepository().addSchedule(schedule).then((_) {
        okMessageDialog(context, 'Created!', 'Route Scheduled Successfully');
        context.go("/profile");
      }).catchError((error) {
        okMessageDialog(context, 'Failed!', error.toString());
      });
    }
  }
}
