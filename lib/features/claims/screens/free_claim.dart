import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/colors.dart';
import '../../auth/widgets/auth_button.dart';
import '../../auth/widgets/auth_textfield.dart';

class FreeClaimScreen extends StatefulWidget {
  const FreeClaimScreen({super.key});

  @override
  State<FreeClaimScreen> createState() => _FreeClaimScreenState();
}

class _FreeClaimScreenState extends State<FreeClaimScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController claimTitleController = TextEditingController();
  final TextEditingController claimDescriptionController =
      TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    claimTitleController.dispose();
    claimDescriptionController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void submitClaim() async {
    if (claimTitleController.text.isEmpty ||
        claimDescriptionController.text.isEmpty ||
        _selectedImage == null) {
      _showSnackBar("Please fill all fields", isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    _showSnackBar("Claim submitted successfully");
    Navigator.pushReplacementNamed(context, '/claimlist');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showImageSourceModal() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth < 600 ? 130 : 170;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Add Photo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: buttonWidth,
                    child: _ImageSourceOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context); // ✅ close sheet first

                        // ✅ open camera AFTER sheet closes
                        Future.delayed(const Duration(milliseconds: 250), () {
                          pickImage(ImageSource.camera);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: _ImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);

                        Future.delayed(const Duration(milliseconds: 250), () {
                          pickImage(ImageSource.gallery);
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('File a Claim'),
        centerTitle: true,
      ),

      // ✅ RESPONSIVE BODY
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          double maxWidth;
          if (width >= 1024) {
            maxWidth = 700; // Desktop
          } else if (width >= 600) {
            maxWidth = 600; // Tablet
          } else {
            maxWidth = double.infinity; // Mobile
          }

          return FadeTransition(
            opacity: _fadeAnimation!,
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width < 600 ? 16 : 24,
                      vertical: 20,
                    ),
                    child: _buildFormContent(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ================= FORM CONTENT =================
  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submit Your Claim',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Fill in the details below'),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const _SectionLabel(label: 'Claim Title'),
        const SizedBox(height: 8),
        AuthTextField(
          controller: claimTitleController,
          hintText: 'Enter claim title',
        ),

        const SizedBox(height: 20),

        const _SectionLabel(label: 'Claim Description'),
        const SizedBox(height: 8),
        AuthTextField(
          controller: claimDescriptionController,
          hintText: 'Describe your claim',
          maxLines: 5,
        ),

        const SizedBox(height: 20),

        const _SectionLabel(label: 'Upload Evidence'),
        const SizedBox(height: 8),

        _selectedImage == null
            ? _ImageUploadCard(onTap: _showImageSourceModal)
            : _ImagePreviewCard(
                image: _selectedImage!,
                onRemove: () => setState(() => _selectedImage = null),
                onReplace: _showImageSourceModal,
              ),

        const SizedBox(height: 32),

        _isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : AuthButton(text: 'Submit Claim', onPressed: submitClaim),
      ],
    );
  }
}

/// ================= REUSABLE WIDGETS =================

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class _ImageUploadCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ImageUploadCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_photo_alternate, size: 40),
              SizedBox(height: 8),
              Text('Tap to upload image'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePreviewCard extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;
  final VoidCallback onReplace;

  const _ImagePreviewCard({
    required this.image,
    required this.onRemove,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(image, height: 220, fit: BoxFit.cover),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onReplace,
                child: const Text('Replace'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: onRemove,
                child: const Text('Remove'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

