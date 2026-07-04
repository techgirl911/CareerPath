import 'package:flutter/material.dart';
import '../app_constants.dart';
import '../app_colors.dart';

class UploadResultsScreen extends StatefulWidget {
  const UploadResultsScreen({Key? key}) : super(key: key);

  @override
  State<UploadResultsScreen> createState() => _UploadResultsScreenState();
}

class _UploadResultsScreenState extends State<UploadResultsScreen> {
  String? _selectedDocType;
  String? _selectedFileName;
  bool _isUploading = false;
  String? _uploadMessage;

  final List<Map<String, String>> _docTypes = [
    {
      'value': AppConstants.docTypeTranscript,
      'label': 'Transcript',
      'description': 'Official academic transcript'
    },
    {
      'value': AppConstants.docTypeReportCard,
      'label': 'Report Card',
      'description': 'Student report card'
    },
    {
      'value': AppConstants.docTypeCertificate,
      'label': 'Certificate',
      'description': 'Academic certificate'
    },
    {
      'value': AppConstants.docTypeOther,
      'label': 'Other',
      'description': 'Other academic document'
    },
  ];

  Future<void> _pickFile() async {
    // Simulate file picking
    setState(() {
      _selectedFileName = 'sample_transcript.pdf';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File selected: sample_transcript.pdf'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _uploadFile() async {
    if (_selectedDocType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select document type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadMessage = null;
    });

    try {
      // Simulate upload
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _uploadMessage = 'File uploaded successfully!';
        _selectedFileName = null;
        _selectedDocType = null;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Upload successful!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

      // Reset form
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _uploadMessage = null);
        }
      });
    } catch (e) {
      setState(() {
        _uploadMessage = 'Upload failed: $e';
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Academic Results'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Card(
              color: AppColors.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Upload your academic documents to help us recommend suitable careers',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Success Message
            if (_uploadMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _uploadMessage!,
                        style: TextStyle(color: AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Document Type Selection
            Text(
              'Document Type',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ..._docTypes.map((docType) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    color: _selectedDocType == docType['value']
                        ? AppColors.primary.withOpacity(0.1)
                        : null,
                    child: RadioListTile<String>(
                      title: Text(docType['label']!),
                      subtitle: Text(docType['description']!),
                      value: docType['value']!,
                      groupValue: _selectedDocType,
                      onChanged: (value) {
                        setState(() => _selectedDocType = value);
                      },
                    ),
                  ),
                )),
            const SizedBox(height: 24),

            // File Selection
            Text(
              'Select File',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedFileName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedFileName!,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Selected',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.success,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() => _selectedFileName = null);
                              },
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pickFile,
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Choose File'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Supported formats: PDF, JPG, PNG, DOC',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadFile,
                icon: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(
                  _isUploading ? 'Uploading...' : 'Upload Document',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
