# Poa Supermarkets Flutter Barcode Scanner App

A Flutter app for **Poa Supermarkets** enabling **barcode scanning to automatically input product codes**, reducing manual entry and streamlining product lookup for sales or stock management.

---

## 🚀 Features

✅ Scan product barcodes using the device camera.  
✅ Automatically input scanned code into your forms.  
✅ (Optional) Fetch product details from your Laravel backend using the scanned barcode.  
✅ Clean, beginner-friendly structure for expansion.

---

## 🛠️ Requirements

- Flutter SDK (3.19+ recommended)
- Android/iOS device with a camera
- Backend API (Laravel recommended) for product fetching (optional)

---

## 📦 Dependencies

Add in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  mobile_scanner: ^5.0.1

//base url env
http://127.0.0.1:8000/api/

//authentication 
curl -X 'POST' \
  'http://127.0.0.1:8000/api/login' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'X-CSRF-TOKEN: ' \
  -d '{
  "email": "super.admin@poanamanga.com",
  "password": "SuperAdmin@123"
}'
//response
{
  "user": {
    "id": "87dc9723-9a4a-4889-8f36-503709a2180c",
    "name": "Super Admin",
    "email": "super.admin@poanamanga.com",
    "position": "super user",
    "created_at": "2025-06-24T11:51:27.000000Z",
    "updated_at": "2025-06-24T11:51:27.000000Z",
    "branch": {
      "id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
      "name": "Main Branch",
      "location": "Namanga",
      "contact_number": "0123456789",
      "is_active": true
    },
    "status": "approved",
    "approved_at": null,
    "approved_by": null
  },
  "access_token": "109|0smEzFtetMZbCoWPSuyXY5WoIQH70JkBBFfDSMuHdd9a0f27",
  "token_type": "Bearer"
}
api to fetch branches
curl -X 'GET' \
  'http://127.0.0.1:8000/api/branches' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer 108|9VFt0lP3Qs0Nt1fyShpEJjjPv8THoG4h9Am3gxua1c08449a' \
  -H 'X-CSRF-TOKEN: '
//reponse
{
  "success": true,
  "message": "Success",
  "data": {
    "branches": [
      {
        "id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
        "name": "Main Branch",
        "location": "Namanga",
        "contact_number": "0123456789",
        "is_active": true,
        "created_at": "2025-06-24T11:51:06.000000Z",
        "updated_at": "2025-06-24T11:51:06.000000Z"
      },
      {
        "id": "6f427e12-f956-4c58-ade9-dbccd6394433",
        "name": "Ilala Branch",
        "location": "Ilala",
        "contact_number": "string",
        "is_active": true,
        "created_at": "2025-06-24T14:15:10.000000Z",
        "updated_at": "2025-06-24T14:15:10.000000Z"
      }
    ]
  }
}
//api to fetch products 
curl -X 'GET' \
  'http://127.0.0.1:8000/api/products?branch_id=3916760a-49b9-42b3-a55b-a54f2e2fdde1&search=6203011069365' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer 108|9VFt0lP3Qs0Nt1fyShpEJjjPv8THoG4h9Am3gxua1c08449a' \
  -H 'X-CSRF-TOKEN: '
//reponse
{
  "success": true,
  "message": "Success",
  "data": {
    "statistics": {
      "total_products": 1,
      "out_of_stock_products": 0,
      "low_stock_products": 0,
      "inventory_value": 141400,
      "total_buying_cost": 101000,
      "total_profit_potential": 40400,
      "expired_products": 0,
      "expiring_in_week": 0,
      "expiring_in_month": 1,
      "expiring_in_3_months": 1
    },
    "products": [
      {
        "id": "0f3ddea6-0226-422a-890d-6c8a8074dcde",
        "name": "Mo energy",
        "code": "6203011069365",
        "description": null,
        "price": "700.00",
        "cost_price": "500.00",
        "quantity": 202,
        "is_loan": false,
        "reorder_level": 50,
        "unit": "pcs",
        "category": "drinks",
        "branch_id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
        "created_by": {
          "id": "a39b3828-dcbd-45d5-aab3-62c88c57dc84",
          "name": "string",
          "email": "usermanager@example.com",
          "email_verified_at": null,
          "position_id": "84e1d7cc-aa0c-4c41-9884-0152c031ea7c",
          "branch_id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
          "status": "approved",
          "approved_by": "87dc9723-9a4a-4889-8f36-503709a2180c",
          "approved_at": "2025-06-24T13:33:50.000000Z",
          "rejection_reason": null,
          "created_at": "2025-06-24T13:33:50.000000Z",
          "updated_at": "2025-06-24T13:33:50.000000Z"
        },
        "updated_by": {
          "id": "a39b3828-dcbd-45d5-aab3-62c88c57dc84",
          "name": "string",
          "email": "usermanager@example.com",
          "email_verified_at": null,
          "position_id": "84e1d7cc-aa0c-4c41-9884-0152c031ea7c",
          "branch_id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
          "status": "approved",
          "approved_by": "87dc9723-9a4a-4889-8f36-503709a2180c",
          "approved_at": "2025-06-24T13:33:50.000000Z",
          "rejection_reason": null,
          "created_at": "2025-06-24T13:33:50.000000Z",
          "updated_at": "2025-06-24T13:33:50.000000Z"
        },
        "created_at": "2025-07-06T05:24:42.000000Z",
        "updated_at": "2025-07-07T05:37:09.000000Z",
        "deleted_at": null,
        "profit": 200,
        "branch": {
          "id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
          "name": "Main Branch",
          "location": "Namanga",
          "contact_number": "0123456789",
          "is_active": true,
          "created_at": "2025-06-24T11:51:06.000000Z",
          "updated_at": "2025-06-24T11:51:06.000000Z"
        }
      }
    ]
  }
}
//
if product is not there in the database option to add it in this api, if its there and wants to restock use items 
curl -X 'POST' \
  'http://127.0.0.1:8000/api/batches' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer 108|9VFt0lP3Qs0Nt1fyShpEJjjPv8THoG4h9Am3gxua1c08449a' \
  -H 'Content-Type: application/json' \
  -H 'X-CSRF-TOKEN: ' \
  -d '{
  "supplier_name": "string",
  "branch_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "delivery_date": "2025-07-07",
  "supplier_phone": "string",
  "supplier_email": "string",
  "supplier_address": "string",
  "items": [
    {
      "product_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "quantity": 0,
      "expiry_date": "2025-07-07",
      "loan_amount": 0,
      "loan_paid": 0
    },
    {
      "name": "string",
      "code": "string",
      "description": "string",
      "price": 0,
      "cost_price": 0,
      "quantity": 0,
      "reorder_level": 0,
      "unit": "string",
      "category": "string",
      "expiry_date": "2025-07-07",
      "loan_amount": 0,
      "loan_paid": 0
    }
  ]
}'
//example scanner page
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String scannedCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Product Barcode")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              allowDuplicates: false,
              onDetect: (barcode, args) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  setState(() {
                    scannedCode = code;
                  });
                  Navigator.pop(context, code); // return code to caller
                }
              },
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Scanned Code: $scannedCode',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
//using scanner in my page 
ElevatedButton(
  onPressed: () async {
    final code = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerPage()),
    );
    if (code != null) {
      _productCodeController.text = code; // Autofill form field
      // Optionally fetch product details here
    }
  },
  child: Text("Scan Product"),
);

//permission
<uses-permission android:name="android.permission.CAMERA" />

api to search product by code
curl -X 'GET' \
  'http://127.0.0.1:8000/api/products?search=6203011069365' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer 108|9VFt0lP3Qs0Nt1fyShpEJjjPv8THoG4h9Am3gxua1c08449a' \
  -H 'X-CSRF-TOKEN: '
  //reponse
  {
  "success": true,
  "message": "Success",
  "data": {
    "statistics": {
      "total_products": 1,
      "out_of_stock_products": 0,
      "low_stock_products": 0,
      "inventory_value": 141400,
      "total_buying_cost": 101000,
      "total_profit_potential": 40400,
      "expired_products": 0,
      "expiring_in_week": 0,
      "expiring_in_month": 1,
      "expiring_in_3_months": 1
    },
    "products": [
      {
        "id": "0f3ddea6-0226-422a-890d-6c8a8074dcde",
        "name": "Mo energy",
        "code": "6203011069365",
        "description": null,
        "price": "700.00",
        "cost_price": "500.00",
        "quantity": 202,
        "is_loan": false,
        "reorder_level": 50,
        "unit": "pcs",
        "category": "drinks",
        "branch_id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
        "created_by": {
          "id": "a39b3828-dcbd-45d5-aab3-62c88c57dc84",
          "name": "string",
          "email": "usermanager@example.com",
          "email_verified_at": null,
          "position_id": "84e1d7cc-aa0c-4c41-9884-0152c031ea7c",
          "branch_id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
          "status": "approved",
          "approved_by": "87dc9723-9a4a-4889-8f36-503709a2180c",
          "approved_at": "2025-06-24T13:33:50.000000Z",
          "rejection_reason": null,
          "created_at": "2025-06-24T13:33:50.000000Z",
          "updated_at": "2025-06-24T13:33:50.000000Z"
        },
        "updated_by": {
          "id": "a39b3828-dcbd-45d5-aab3-62c88c57dc84",
          "name": "string",
          "email": "usermanager@example.com",
          "email_verified_at": null,
          "position_id": "84e1d7cc-aa0c-4c41-9884-0152c031ea7c",
          "branch_id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
          "status": "approved",
          "approved_by": "87dc9723-9a4a-4889-8f36-503709a2180c",
          "approved_at": "2025-06-24T13:33:50.000000Z",
          "rejection_reason": null,
          "created_at": "2025-06-24T13:33:50.000000Z",
          "updated_at": "2025-06-24T13:33:50.000000Z"
        },
        "created_at": "2025-07-06T05:24:42.000000Z",
        "updated_at": "2025-07-07T05:37:09.000000Z",
        "deleted_at": null,
        "profit": 200,
        "branch": {
          "id": "3916760a-49b9-42b3-a55b-a54f2e2fdde1",
          "name": "Main Branch",
          "location": "Namanga",
          "contact_number": "0123456789",
          "is_active": true,
          "created_at": "2025-06-24T11:51:06.000000Z",
          "updated_at": "2025-06-24T11:51:06.000000Z"
        }
      }
    ]
  }
}