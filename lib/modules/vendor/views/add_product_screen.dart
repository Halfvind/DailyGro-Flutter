import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../../CommonComponents/CommonWidgets/common_material_button.dart';
import '../../../CommonComponents/CommonWidgets/common_textfield.dart';
import '../../../themes/app_colors.dart';
import '../../../CommonComponents/controllers/global_controller.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _discountController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedUnit = '';
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isFeatured = false;
  bool _isRecommended = false;
  
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _units = [];
  bool _isLoading = true;
  int? _selectedCategoryId;
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadCategories(),
      _loadUnits(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }
  
  Future<void> _loadCategories() async {
    try {
      final response = await GetConnect().get('http://localhost/dailygro/api/vendor/categories_selection');
      if (response.isOk) {
        _categories = List<Map<String, dynamic>>.from(response.body['categories'] ?? []);
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories.first['category_id'];
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories');
    }
  }
  
  Future<void> _loadUnits() async {
    try {
      final response = await GetConnect().get('http://localhost/dailygro/api/vendor/units_selection');
      if (response.isOk) {
        _units = List<Map<String, dynamic>>.from(response.body['units'] ?? []);
        if (_units.isNotEmpty) {
          _selectedUnit = _units.first['name'];
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load units');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    const SizedBox(height: 20),
                    _buildBasicInfo(),
                    const SizedBox(height: 20),
                    _buildPricingSection(),
                    const SizedBox(height: 20),
                    _buildStockSection(),
                    const SizedBox(height: 20),
                    _buildFeaturesSection(),
                    const SizedBox(height: 30),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAddImageCard(),
              ..._selectedImages.map((image) => _buildImageCard(image)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
            Text('Add Image', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(File imageFile) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(imageFile),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(imageFile),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Basic Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        CommonTextField(
          controller: _nameController,
          hintText: 'Product Name',
          validator: (value) => value?.isEmpty == true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField(
          value: _selectedCategoryId,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          items: _categories
              .map((cat) => DropdownMenuItem(
                    value: cat['category_id'],
                    child: Text(cat['name']),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedCategoryId = value as int?),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Product Description',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pricing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                controller: _priceController,
                hintText: 'Selling Price',
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CommonTextField(
                controller: _originalPriceController,
                hintText: 'Original Price',
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField(
                value: _selectedUnit,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
                items: _units
                    .map((unit) => DropdownMenuItem(
                          value: unit['name'],
                          child: Text(unit['name']),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedUnit = value.toString()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CommonTextField(
                controller: _weightController,
                hintText: 'Weight (e.g., 1kg)',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stock Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        CommonTextField(
          controller: _stockController,
          hintText: 'Initial Stock Quantity',
          keyboardType: TextInputType.number,
          validator: (value) => value?.isEmpty == true ? 'Required' : null,
        ),
      ],
    );
  }
  
  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Featured Product: '),
            Radio<bool>(
              value: true,
              groupValue: _isFeatured,
              onChanged: (value) => setState(() => _isFeatured = value!),
            ),
            const Text('Yes'),
            Radio<bool>(
              value: false,
              groupValue: _isFeatured,
              onChanged: (value) => setState(() => _isFeatured = value!),
            ),
            const Text('No'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Recommended: '),
            Radio<bool>(
              value: true,
              groupValue: _isRecommended,
              onChanged: (value) => setState(() => _isRecommended = value!),
            ),
            const Text('Yes'),
            Radio<bool>(
              value: false,
              groupValue: _isRecommended,
              onChanged: (value) => setState(() => _isRecommended = value!),
            ),
            const Text('No'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CommonButton(
            text: 'Add Product',
            onPressed: _addProduct,
          ),
        ),
      ],
    );
  }

  void _pickImage() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Image Source', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    _pickImageFromSource(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.camera_alt, size: 32, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      const Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    _pickImageFromSource(ImageSource.gallery);
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.photo_library, size: 32, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      const Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        Get.snackbar('Success', 'Image added successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  void _removeImage(File imageFile) {
    setState(() {
      _selectedImages.remove(imageFile);
    });
  }

  void _addProduct() async {
    if (_formKey.currentState?.validate() == true) {
      if (_selectedCategoryId == null) {
        Get.snackbar('Error', 'Please select a category');
        return;
      }

      setState(() => _isLoading = true);

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost/dailygro/api/vendor/add_product'),
        );

        // Add form fields
        request.fields['vendor_id'] = Get.find<GlobalController>().vendorId.toString();
        request.fields['category_id'] = _selectedCategoryId.toString();
        request.fields['name'] = _nameController.text.trim();
        request.fields['description'] = _descriptionController.text.trim();
        request.fields['price'] = _priceController.text;
        request.fields['original_price'] = _originalPriceController.text;
        request.fields['stock_quantity'] = _stockController.text;
        request.fields['unit'] = _selectedUnit;
        request.fields['weight'] = _weightController.text.trim();
        request.fields['is_featured'] = (_isFeatured ? 1 : 0).toString();
        request.fields['is_recommended'] = (_isRecommended ? 1 : 0).toString();

        // Debug print all fields
        print('>>>> Fields being sent:');
        request.fields.forEach((key, value) {
          print('$key: $value');
        });

        // Add image file if selected
        if (_selectedImages.isNotEmpty) {
          print('>>>> Adding image file: ${_selectedImages.first.path}');
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            _selectedImages.first.path,
          ));
        } else {
          print('>>>> No image selected');
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        print('>>>> Response Status: ${response.statusCode}');
        print('>>>> Response Body: $jsonResponse');

        if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
          Get.back();
          Get.snackbar('Success', 'Product added successfully');
        } else {
          Get.snackbar('Error', jsonResponse['message'] ?? 'Failed to add product');
        }
      } catch (e) {
        print('>>>> Exception: $e');
        Get.snackbar('Error', 'Network error occurred');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}