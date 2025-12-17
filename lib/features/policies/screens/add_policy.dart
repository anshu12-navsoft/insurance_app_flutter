import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class AddPolicyScreen extends StatefulWidget {
  const AddPolicyScreen({super.key});

  @override
  State<AddPolicyScreen> createState() => _AddPolicyScreenState();
}

class _AddPolicyScreenState extends State<AddPolicyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _policyNumberController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _premiumController = TextEditingController();
  final TextEditingController _coverageController = TextEditingController();

  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  PolicyType? _selectedPolicyType;
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedPaymentFrequency = 'Monthly';
  bool _isSubmitting = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _policyNumberController.dispose();
    _holderNameController.dispose();
    _premiumController.dispose();
    _coverageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Add New Policy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _fadeAnimation == null
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation!,
              child: Column(
                children: [
                  _buildProgressIndicator(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? screenWidth * 0.15 : 20,
                        vertical: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: isWeb
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (_currentStep == 0)
                                          _buildPolicyTypeStep(),
                                        if (_currentStep == 1)
                                          _buildBasicInfoStep(),
                                        if (_currentStep == 2)
                                          _buildCoverageStep(),
                                        if (_currentStep == 3)
                                          _buildReviewStep(),
                                      ],
                                    ),
                                  ),
                                  if (_currentStep == 3)
                                    const SizedBox(width: 32),
                                  if (_currentStep == 3)
                                    Expanded(
                                      flex: 1,
                                      child: _buildSummaryCard(),
                                    ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_currentStep == 0) _buildPolicyTypeStep(),
                                  if (_currentStep == 1) _buildBasicInfoStep(),
                                  if (_currentStep == 2) _buildCoverageStep(),
                                  if (_currentStep == 3) _buildReviewStep(),
                                ],
                              ),
                      ),
                    ),
                  ),
                  _buildNavigationButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildNavigationButtons() {
    final isWeb = kIsWeb;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 900 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isWeb
                  // 🌐 WEB LAYOUT (NO Expanded)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep > 0)
                          SizedBox(
                            width: 140,
                            child: OutlinedButton(
                              onPressed: () => setState(() => _currentStep--),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 12),
                        SizedBox(
                          width: 220,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _handleNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _currentStep < 3
                                        ? 'Continue'
                                        : 'Submit Policy',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    )
                  // 📱 MOBILE LAYOUT (Expanded OK)
                  : Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => _currentStep--),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _handleNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _currentStep < 3
                                        ? 'Continue'
                                        : 'Submit Policy',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: List.generate(4, (index) {
          final isCompleted = index < _currentStep;
          final isActive = index == _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? AppColors.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 3) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPolicyTypeCard(PolicyType type, String description) {
    final isSelected = _selectedPolicyType == type;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPolicyType = type;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? type.color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: type.color.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: type.gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(type.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: type.color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPolicyTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          '1. Choose Policy Type',
          'Select the type of insurance policy',
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildPolicyTypeCard(
              PolicyType.health,
              'Complete healthcare coverage for you and your family',
            ),
            _buildPolicyTypeCard(
              PolicyType.car,
              'Comprehensive coverage for your vehicle',
            ),
            _buildPolicyTypeCard(
              PolicyType.life,
              'Secure your family\'s financial future',
            ),
            _buildPolicyTypeCard(
              PolicyType.home,
              'Protection for your home and belongings',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep() {
    final isWeb = kIsWeb;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('2. Basic Information', 'Enter your policy details'),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _policyNumberController,
          label: 'Policy Number',
          hint: 'e.g., POL123456',
          icon: Icons.numbers,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter policy number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _holderNameController,
          label: 'Policy Holder Name',
          hint: 'Enter full name',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter holder name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        isWeb
            ? Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _startDate = picked);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePicker(
                      label: 'End Date',
                      date: _endDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: _startDate ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _endDate = picked);
                        }
                      },
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildDatePicker(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDatePicker(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date) : 'Select date',
                    style: TextStyle(
                      fontSize: 15,
                      color: date != null ? Colors.black87 : Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverageStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          '3. Coverage Details',
          'Set your premium and coverage amount',
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _premiumController,
          label: 'Premium Amount',
          hint: 'Enter amount',
          icon: Icons.payments,
          prefix: '\$ ',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter premium amount';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildPaymentFrequencySelector(),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _coverageController,
          label: 'Coverage Amount',
          hint: 'Enter coverage amount',
          icon: Icons.shield,
          prefix: '\$ ',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter coverage amount';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Coverage amount represents the maximum claim you can make under this policy.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue[900],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary),
            prefixText: prefix,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentFrequencySelector() {
    final frequencies = ['Monthly', 'Quarterly', 'Yearly'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Frequency',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: frequencies.map((frequency) {
              final isSelected = _selectedPaymentFrequency == frequency;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedPaymentFrequency = frequency;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      frequency,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          '4. Review & Confirm',
          'Please verify all information',
        ),
        const SizedBox(height: 24),
        _buildSummaryCard(),
      ],
    );
  }

  Widget _buildReviewItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          if (_selectedPolicyType != null)
            _buildReviewItem(
              icon: _selectedPolicyType!.icon,
              label: 'Policy Type',
              value: _selectedPolicyType!.displayName,
              color: _selectedPolicyType!.color,
            ),
          const Divider(height: 32),
          _buildReviewItem(
            icon: Icons.numbers,
            label: 'Policy Number',
            value: _policyNumberController.text,
            color: Colors.blue,
          ),
          const Divider(height: 32),
          _buildReviewItem(
            icon: Icons.person,
            label: 'Policy Holder',
            value: _holderNameController.text,
            color: Colors.purple,
          ),
          const Divider(height: 32),
          _buildReviewItem(
            icon: Icons.payments,
            label: 'Premium',
            value: '\$${_premiumController.text} / $_selectedPaymentFrequency',
            color: Colors.green,
          ),
          const Divider(height: 32),
          _buildReviewItem(
            icon: Icons.shield,
            label: 'Coverage',
            value: '\$${_coverageController.text}',
            color: Colors.orange,
          ),
          const Divider(height: 32),
          _buildReviewItem(
            icon: Icons.calendar_today,
            label: 'Duration',
            value: '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleNext() async {
    if (_currentStep == 0) {
      if (_selectedPolicyType == null) {
        _showSnackBar('Please select a policy type', isError: true);
        return;
      }
      setState(() => _currentStep++);
    } else if (_currentStep == 1) {
      if (_startDate == null || _endDate == null) {
        _showSnackBar('Please select start and end dates', isError: true);
        return;
      }
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 2) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 3) {
      await _submitPolicy();
    }
  }

  Future<void> _submitPolicy() async {
    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    _showSnackBar('Policy added successfully!');

    // Navigate back to policies list
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pop(context);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Policy Type Enum (reuse from previous file) enum PolicyType { health, car, life, home; String get displayName { switch (this) { case PolicyType.health: return 'Health Insurance'; case PolicyType.car: return 'Car Insurance'; case PolicyType.life: return 'Life Insurance'; case PolicyType.home: return 'Home Insurance'; } }
  // Existing helper widgets (_buildStepHeader, _buildPolicyTypeCard, _buildTextField, _buildDatePicker, _buildPaymentFrequencySelector, _buildReviewItem, _buildNavigationButtons, _handleNext, _submitPolicy, _showSnackBar, _formatDate) remain the same
  // No need to repeat here for brevity
}

enum PolicyType {
  health,
  car,
  life,
  home;

  String get displayName {
    switch (this) {
      case PolicyType.health:
        return 'Health Insurance';
      case PolicyType.car:
        return 'Car Insurance';
      case PolicyType.life:
        return 'Life Insurance';
      case PolicyType.home:
        return 'Home Insurance';
    }
  }

  Color get color {
    switch (this) {
      case PolicyType.health:
        return const Color(0xFF667eea);
      case PolicyType.car:
        return const Color(0xFF4facfe);
      case PolicyType.life:
        return const Color(0xFF43e97b);
      case PolicyType.home:
        return const Color(0xFFfa709a);
    }
  }

  IconData get icon {
    switch (this) {
      case PolicyType.health:
        return Icons.favorite;
      case PolicyType.car:
        return Icons.directions_car;
      case PolicyType.life:
        return Icons.family_restroom;
      case PolicyType.home:
        return Icons.home;
    }
  }

  Gradient get gradient {
    switch (this) {
      case PolicyType.health:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        );
      case PolicyType.car:
        return const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        );
      case PolicyType.life:
        return const LinearGradient(
          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
        );
      case PolicyType.home:
        return const LinearGradient(
          colors: [Color(0xFFfa709a), Color(0xFFfee140)],
        );
    }
  }
}

// PolicyType Enum remains the same
