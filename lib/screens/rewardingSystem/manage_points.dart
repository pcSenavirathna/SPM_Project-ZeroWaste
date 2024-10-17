import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/repositories/points_repository.dart';
import 'package:zero_waste/models/points.dart';
import 'package:zero_waste/widgets/text_field_input.dart';
import 'package:zero_waste/widgets/submit_button.dart';

class PointsCreateScreen extends StatefulWidget {
  const PointsCreateScreen({super.key});

  @override
  State<PointsCreateScreen> createState() => _PointsCreatePageState();
}

class _PointsCreatePageState extends State<PointsCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plasticPointsController = TextEditingController();
  final _glassPointsController = TextEditingController();
  final _paperPointsController = TextEditingController();
  final _organicPointsController = TextEditingController();
  final _metalPointsController = TextEditingController();
  final _eWastePointsController = TextEditingController();

  bool _isDataLoaded = false;
  bool _isCreatingNew = false;

  Future<void> _loadPoints() async {
    try {
      Points? points = await PointsRepository().getPointDetails();
      if (points != null) {
        _plasticPointsController.text = points.plasticPointsPerKg.toString();
        _glassPointsController.text = points.glassPointsPerKg.toString();
        _paperPointsController.text = points.paperPointsPerKg.toString();
        _organicPointsController.text = points.organicPointsPerKg.toString();
        _metalPointsController.text = points.metalPointsPerKg.toString();
        _eWastePointsController.text = points.eWastePointsPerKg.toString();
        setState(() {
          _isCreatingNew = false;
        });
      } else {
        _plasticPointsController.text = '0.0';
        _glassPointsController.text = '0.0';
        _paperPointsController.text = '0.0';
        _organicPointsController.text = '0.0';
        _metalPointsController.text = '0.0';
        _eWastePointsController.text = '0.0';
        setState(() {
          _isCreatingNew = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading points details: $e')),
      );
    }
    setState(() {
      _isDataLoaded = true;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Points points = Points(
        plasticPointsPerKg:
            double.tryParse(_plasticPointsController.text) ?? 0.0,
        glassPointsPerKg: double.tryParse(_glassPointsController.text) ?? 0.0,
        paperPointsPerKg: double.tryParse(_paperPointsController.text) ?? 0.0,
        organicPointsPerKg:
            double.tryParse(_organicPointsController.text) ?? 0.0,
        metalPointsPerKg: double.tryParse(_metalPointsController.text) ?? 0.0,
        eWastePointsPerKg: double.tryParse(_eWastePointsController.text) ?? 0.0,
      );

      try {
        if (_isCreatingNew) {
          await PointsRepository().createPoints(points);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Points created successfully')),
          );
          _clearInputFields();
        } else {
          await PointsRepository().updatePoints(points);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Points updated successfully')),
          );
          _clearInputFields();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving points details: $e')),
        );
      }
    }
  }

  void _resetPoints() async {
    try {
      await PointsRepository().resetPoints();
      _clearInputFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Points reset to zero')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resetting points details: $e')),
      );
    }
  }

  void _clearInputFields() {
    _plasticPointsController.clear();
    _glassPointsController.clear();
    _paperPointsController.clear();
    _organicPointsController.clear();
    _metalPointsController.clear();
    _eWastePointsController.clear();
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final number = double.tryParse(value);
    if (number == null || number < -1) {
      return 'Please enter a positive number';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isDataLoaded
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                      expandedHeight: 40.0,
                      backgroundColor: Colors.green,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        background: Container(
                          color: Colors.green,
                        ),
                        title: const Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Update Points Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          context.go('/home');
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldInput(
                                icon: Icons.recycling,
                                title: "Plastic Points per Kg",
                                controller: _plasticPointsController,
                                inputType: TextInputType.number,
                                validator: _validatePositiveNumber,
                              ),
                              const SizedBox(height: 16),
                              TextFieldInput(
                                icon: Icons.grass,
                                title: "Glass Points per Kg",
                                controller: _glassPointsController,
                                inputType: TextInputType.number,
                                validator: _validatePositiveNumber,
                              ),
                              const SizedBox(height: 16),
                              TextFieldInput(
                                icon: Icons.article,
                                title: "Paper Points per Kg",
                                controller: _paperPointsController,
                                inputType: TextInputType.number,
                                validator: _validatePositiveNumber,
                              ),
                              const SizedBox(height: 16),
                              TextFieldInput(
                                icon: Icons.eco,
                                title: "Organic Points per Kg",
                                controller: _organicPointsController,
                                inputType: TextInputType.number,
                                validator: _validatePositiveNumber,
                              ),
                              const SizedBox(height: 16),
                              TextFieldInput(
                                icon: Icons.build,
                                title: "Metal Points per Kg",
                                controller: _metalPointsController,
                                inputType: TextInputType.number,
                                validator: _validatePositiveNumber,
                              ),
                              const SizedBox(height: 16),
                              TextFieldInput(
                                icon: Icons.memory,
                                title: "e-Waste Points per Kg",
                                controller: _eWastePointsController,
                                inputType: TextInputType.number,
                                validator: _validatePositiveNumber,
                              ),
                              const SizedBox(height: 24),
                              SubmitButton(
                                icon: Icons.save,
                                text: _isCreatingNew
                                    ? 'Save Points'
                                    : 'Update Points',
                                whenPressed: (context) => _submitForm(),
                              ),
                              const SizedBox(height: 16),
                              SubmitButton(
                                icon: Icons.refresh,
                                text: 'Reset Points',
                                whenPressed: (context) => _resetPoints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
