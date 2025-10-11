// screens/upload_screen.dart
import 'package:flutter/material.dart';
import 'firebase_uploader.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isUploading = false;
  String _uploadStatus = '';

  Future<void> _uploadProducts() async {
    setState(() {
      _isUploading = true;
      _uploadStatus = 'Starting upload...';
    });

    try {
      await FirebaseUploader.uploadProducts();
      setState(() {
        _uploadStatus =
            '✅ Upload completed successfully!\nCheck console for details.';
      });
    } catch (e) {
      setState(() {
        _uploadStatus = '❌ Upload failed: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Products'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 80, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Firebase Product Uploader',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              // FIXED: Changed to productList (singular)
              'Upload ${FirebaseUploader.productList.length} products to Firebase',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            if (_isUploading) ...[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Uploading products...', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
            ],

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _uploadStatus,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isUploading ? null : _uploadProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isUploading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Uploading...'),
                      ],
                    )
                  : Text('Upload All Products', style: TextStyle(fontSize: 18)),
            ),

            SizedBox(height: 15),

            Text(
              'Make sure Firebase Firestore rules allow writes',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
