import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/product_provider.dart';
import '../providers/branch_provider.dart';
import '../widgets/product_details_sheet.dart';
import '../widgets/add_product_form.dart';
import '../utils/app_theme.dart';
import '../services/api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String code = barcodes.first.rawValue ?? '';
      if (code.isNotEmpty) {
        setState(() {
          isScanning = false;
        });
        _searchProduct(code);
      }
    }
  }

  void _resetScanning() {
    setState(() {
      isScanning = true;
    });
  }

  Future<void> _searchProduct(String code) async {
    final productProvider = context.read<ProductProvider>();
    final branchProvider = context.read<BranchProvider>();
    final product = await productProvider.searchProductByCode(code);

    if (mounted) {
      if (product != null) {
        // Get detailed product info across all branches
        final productDetails = await ApiService.searchProductAcrossBranches(
          code,
        );

        // Show product found dialog with details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(child: Text('Product Found!')),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                if (productDetails != null) ...[
                  Text(
                    'Total Quantity: ${productDetails['product_info']['total_quantity']}',
                  ),
                  Text(
                    'Average Price: TZS ${productDetails['product_info']['average_price']}',
                  ),
                  Text(
                    'Total Sales: ${productDetails['product_info']['total_sales']}',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Available in ${productDetails['branch_details'].length} branch(es)',
                  ),
                ] else ...[
                  Text(
                    'Branch: ${product.branch?.name ?? branchProvider.selectedBranch?.name ?? 'Unknown'}',
                  ),
                  Text(
                    'Quantity: ${product.quantity} ${product.unit ?? 'units'}',
                  ),
                  Text(
                    'Selling Price: TZS ${product.price.toStringAsFixed(0)}',
                  ),
                  Text(
                    'Cost Price: TZS ${product.costPrice.toStringAsFixed(0)}',
                  ),
                ],
                if (product.code != null) Text('Code: ${product.code}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetScanning();
                },
                child: const Text('Continue Scanning'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Show full product details in modal bottom sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
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
                              Text(
                                'Product Details',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),

                              if (productDetails != null) ...[
                                // Product Overview
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Overview',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        ListTile(
                                          leading: const Icon(Icons.inventory),
                                          title: const Text('Product Name'),
                                          subtitle: Text(
                                            productDetails['product_info']['name'],
                                          ),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.qr_code),
                                          title: const Text('Product Code'),
                                          subtitle: Text(
                                            productDetails['product_info']['code'],
                                          ),
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.description,
                                          ),
                                          title: const Text('Description'),
                                          subtitle: Text(
                                            productDetails['product_info']['description'] ??
                                                'N/A',
                                          ),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.analytics),
                                          title: const Text('Total Quantity'),
                                          subtitle: Text(
                                            '${productDetails['product_info']['total_quantity']} units',
                                          ),
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.trending_up,
                                          ),
                                          title: const Text('Total Sales'),
                                          subtitle: Text(
                                            '${productDetails['product_info']['total_sales']}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Branch Details
                                Text(
                                  'Available in Branches',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...productDetails['branch_details'].map<
                                  Widget
                                >((branchDetail) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            branchDetail['branch']['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.primaryRed,
                                                ),
                                          ),
                                          Text(
                                            'Location: ${branchDetail['branch']['location']}',
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Quantity: ${branchDetail['product_details']['quantity']}',
                                                    ),
                                                    Text(
                                                      'Price: TZS ${branchDetail['product_details']['price']}',
                                                    ),
                                                    Text(
                                                      'Cost: TZS ${branchDetail['product_details']['cost_price']}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Sales: ${branchDetail['sales_summary']['total_sales']}',
                                                    ),
                                                    Text(
                                                      'Sold: ${branchDetail['sales_summary']['total_quantity_sold']}',
                                                    ),
                                                    Text(
                                                      'Reorder Level: ${branchDetail['product_details']['reorder_level']}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ] else ...[
                                // Fallback to simple product details
                                ListTile(
                                  leading: const Icon(Icons.inventory),
                                  title: const Text('Name'),
                                  subtitle: Text(product.name),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.qr_code),
                                  title: const Text('Code'),
                                  subtitle: Text(product.code ?? 'N/A'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.description),
                                  title: const Text('Description'),
                                  subtitle: Text(product.description ?? 'N/A'),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ).then((_) {
                    _resetScanning();
                  });
                },
                child: const Text('View Details'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Show restock form
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddProductForm(
                      scannedCode: code,
                      existingProduct: product,
                    ),
                  ).then((_) {
                    _resetScanning();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Restock'),
              ),
            ],
          ),
        );
      } else {
        // Product not found
        if (mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddProductForm(
              scannedCode: code,
              existingProduct: null, // No existing product for new additions
            ),
          ).then((_) {
            _resetScanning();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: cameraController, onDetect: _onDetect),
          // Scanning overlay
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: AppTheme.primaryRed,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isScanning
                          ? 'Point camera at barcode to scan'
                          : 'Processing...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (!isScanning) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _resetScanning,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Scan Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show dialog to manually enter barcode for testing
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController(text: '6203011060344');
              return AlertDialog(
                title: const Text('Test Barcode'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Enter a barcode to test:'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Barcode',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          isScanning = false;
                        });
                        _searchProduct(controller.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Input Code'),
      ),
    );
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);
    Path holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutSize,
            height: cutOutSize,
          ),
          Radius.circular(borderRadius),
        ),
      );
    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final borderWidthSize = width / 2;
    final borderHeightSize = height / 2;
    final cutOutWidth = cutOutSize;
    final cutOutHeight = cutOutSize;

    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutWidth,
            height: cutOutHeight,
          ),
          Radius.circular(borderRadius),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, paint);

    // Draw the border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final borderPath = Path();

    // Top left
    borderPath.moveTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2 + borderLength,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.moveTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2 + borderLength,
    );

    // Top right
    borderPath.moveTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2 - borderLength,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.moveTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2 + borderLength,
    );

    // Bottom left
    borderPath.moveTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2 + borderLength,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.moveTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2 - borderLength,
    );

    // Bottom right
    borderPath.moveTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2 - borderLength,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.moveTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2 - borderLength,
    );

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
