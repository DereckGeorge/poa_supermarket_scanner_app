import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/batch.dart';
import '../models/user.dart'; // Branch is defined here
import '../providers/branch_provider.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

class AddProductForm extends StatefulWidget {
  final String? scannedCode;
  final Product? existingProduct; // For restocking

  const AddProductForm({Key? key, this.scannedCode, this.existingProduct})
    : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _reorderLevelController = TextEditingController();
  final _unitController = TextEditingController();
  final _categoryController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _loanPaidController = TextEditingController();
  final _supplierNameController = TextEditingController();
  final _supplierPhoneController = TextEditingController();
  final _supplierEmailController = TextEditingController();
  final _supplierAddressController = TextEditingController();

  bool _isLoading = false;
  bool get _isRestocking => widget.existingProduct != null;
  Branch? _selectedBranch;

  @override
  void initState() {
    super.initState();

    // Fetch branches if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final branchProvider = context.read<BranchProvider>();
      if (branchProvider.branches.isEmpty) {
        branchProvider.fetchBranches();
      }
    });

    // Set default supplier information
    _supplierNameController.text = 'test supplier';
    _supplierPhoneController.text = '0748281701';
    _supplierEmailController.text = 'eridericgeorge@gmail.com';
    _supplierAddressController.text = 'makumbusho';

    if (widget.scannedCode != null) {
      _codeController.text = widget.scannedCode!;
    }

    if (_isRestocking && widget.existingProduct != null) {
      // Pre-fill existing product data
      final product = widget.existingProduct!;
      _nameController.text = product.name;
      _codeController.text = product.code ?? '';
      _descriptionController.text = product.description ?? '';
      _priceController.text = product.price.toString();
      _costPriceController.text = product.costPrice.toString();
      _reorderLevelController.text = product.reorderLevel.toString();
      _unitController.text = product.unit ?? '';
      _categoryController.text = product.category ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _quantityController.dispose();
    _reorderLevelController.dispose();
    _unitController.dispose();
    _categoryController.dispose();
    _expiryDateController.dispose();
    _loanAmountController.dispose();
    _loanPaidController.dispose();
    _supplierNameController.dispose();
    _supplierPhoneController.dispose();
    _supplierEmailController.dispose();
    _supplierAddressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if branch is selected
    final selectedBranch =
        _selectedBranch ?? context.read<BranchProvider>().selectedBranch;
    if (selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a branch first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final expiryDate = DateTime.tryParse(_expiryDateController.text);
      final loanAmount = double.tryParse(_loanAmountController.text) ?? 0.0;
      final loanPaid = double.tryParse(_loanPaidController.text) ?? 0.0;

      BatchItem item;

      if (_isRestocking) {
        // For existing product - only send product_id and restocking info
        item = BatchItem(
          productId: widget.existingProduct!.id,
          quantity: int.parse(_quantityController.text),
          expiryDate: expiryDate,
          loanAmount: loanAmount,
          loanPaid: loanPaid,
        );
      } else {
        // For new product - send all product details
        item = BatchItem(
          name: _nameController.text.trim(),
          code: _codeController.text.trim().isEmpty
              ? null
              : _codeController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          price: double.parse(_priceController.text),
          costPrice: _costPriceController.text.trim().isEmpty
              ? 0.0
              : double.parse(_costPriceController.text),
          quantity: int.parse(_quantityController.text),
          reorderLevel: _reorderLevelController.text.trim().isEmpty
              ? 0
              : int.parse(_reorderLevelController.text),
          unit: _unitController.text.trim().isEmpty
              ? 'pcs'
              : _unitController.text.trim(),
          category: _categoryController.text.trim().isEmpty
              ? null
              : _categoryController.text.trim(),
          expiryDate: expiryDate,
          loanAmount: loanAmount,
          loanPaid: loanPaid,
        );
      }

      final batch = Batch(
        supplierName: _supplierNameController.text.trim().isEmpty
            ? 'test supplier'
            : _supplierNameController.text.trim(),
        branchId: selectedBranch.id,
        deliveryDate: DateTime.now(),
        supplierPhone: _supplierPhoneController.text.trim().isEmpty
            ? '0748281701'
            : _supplierPhoneController.text.trim(),
        supplierEmail: _supplierEmailController.text.trim().isEmpty
            ? 'eridericgeorge@gmail.com'
            : _supplierEmailController.text.trim(),
        supplierAddress: _supplierAddressController.text.trim().isEmpty
            ? 'makumbusho'
            : _supplierAddressController.text.trim(),
        items: [item],
      );

      // Debug logging
      print('Batch supplier data:');
      print('Name: ${batch.supplierName}');
      print('Phone: ${batch.supplierPhone}');
      print('Email: ${batch.supplierEmail}');
      print('Address: ${batch.supplierAddress}');
      print('Batch JSON: ${batch.toJson()}');

      await ApiService.createBatch(batch);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isRestocking
                  ? 'Product restocked successfully!'
                  : 'Product added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isRestocking
                  ? 'Failed to restock product: $e'
                  : 'Failed to add product: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.98,
        expand: false,
        builder: (context, scrollController) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      _isRestocking ? 'Restock Product' : 'Add New Product',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryRed,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Branch Selection
                    Text(
                      'Branch Selection',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Consumer<BranchProvider>(
                      builder: (context, branchProvider, child) {
                        if (branchProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (branchProvider.branches.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('No branches available'),
                          );
                        }

                        return DropdownButtonFormField<Branch>(
                          value:
                              _selectedBranch ?? branchProvider.selectedBranch,
                          decoration: const InputDecoration(
                            labelText: 'Select Branch *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a branch';
                            }
                            return null;
                          },
                          items: branchProvider.branches.map((branch) {
                            return DropdownMenuItem<Branch>(
                              value: branch,
                              child: Text(
                                '${branch.name} - ${branch.location}',
                              ),
                            );
                          }).toList(),
                          onChanged: (Branch? newValue) {
                            setState(() {
                              _selectedBranch = newValue;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Product Information Section
                    Text(
                      'Product Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name *',
                        border: OutlineInputBorder(),
                      ),
                      enabled: !_isRestocking,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Product Code and Unit
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codeController,
                            decoration: const InputDecoration(
                              labelText: 'Product Code *',
                              border: OutlineInputBorder(),
                            ),
                            enabled: !_isRestocking,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Expanded(
                        //   child: TextFormField(
                        //     controller: _unitController,
                        //     decoration: const InputDecoration(
                        //       labelText: 'Unit',
                        //       border: OutlineInputBorder(),
                        //     ),
                        //     enabled: !_isRestocking,
                        //     validator: (value) {
                        //       // Unit is now optional
                        //       return null;
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description (only for new products)
                    if (!_isRestocking) ...[
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Pricing Information
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Selling Price (TZS) *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            enabled: !_isRestocking,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _costPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Cost Price (TZS)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            enabled: !_isRestocking,
                            validator: (value) {
                              // Cost price is now optional
                              if (value != null && value.trim().isNotEmpty) {
                                if (double.tryParse(value) == null) {
                                  return 'Invalid number';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Category and Reorder Level (only for new products)
                    if (!_isRestocking) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                // Category is now optional
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _reorderLevelController,
                              decoration: const InputDecoration(
                                labelText: 'Reorder Level',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                // Reorder level is now optional
                                if (value != null && value.trim().isNotEmpty) {
                                  if (int.tryParse(value) == null) {
                                    return 'Invalid number';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Stock Information Section
                    Text(
                      'Stock Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quantity and Expiry Date
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Quantity *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _expiryDateController,
                            decoration: InputDecoration(
                              labelText: 'Expiry Date',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () =>
                                    _selectDate(_expiryDateController),
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              // Expiry date is now optional
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isRestocking
                                    ? 'Restock Product'
                                    : 'Add Product',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
