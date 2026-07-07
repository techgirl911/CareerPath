import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_constants.dart';

class UploadResultsScreen extends StatefulWidget {
  final String? studentId;

  const UploadResultsScreen({
    this.studentId,
    Key? key,
  }) : super(key: key);

  @override
  State<UploadResultsScreen> createState() => _UploadResultsScreenState();
}

class _UploadResultsScreenState extends State<UploadResultsScreen> {
  String? _selectedDocType;
  String? _selectedFileName;
  bool _isUploading = false;
  String? _uploadMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Upload Academic Results',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your transcripts, report cards, or certificates',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),

            // Document Type Selection
            Text(
              'Document Type',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildDocumentTypeOption(
                      value: AppConstants.docTypeTranscript,
                      label: 'Transcript',
                      description: 'Official academic transcript',
                      icon: Icons.description,
                    ),
                    const Divider(),
                    _buildDocumentTypeOption(
                      value: AppConstants.docTypeReportCard,
                      label: 'Report Card',
                      description: 'Semester or term report card',
                      icon: Icons.assignment,
                    ),
                    const Divider(),
                    _buildDocumentTypeOption(
                      value: AppConstants.docTypeCertificate,
                      label: 'Certificate',
                      description: 'Achievement or course certificate',
                      icon: Icons.card_giftcard,
                    ),
                    const Divider(),
                    _buildDocumentTypeOption(
                      value: AppConstants.docTypeOther,
                      label: 'Other',
                      description: 'Other academic document',
                      icon: Icons.file_present,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // File Selection
            Text(
              'Select File',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: InkWell(
                onTap: _isUploading ? null : _selectFile,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 60,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedFileName ?? 'Tap to select a file',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      if (_selectedFileName != null) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _isUploading ? null : _selectFile,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Choose Different'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Upload Message
            if (_uploadMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _uploadMessage!.contains('Success')
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _uploadMessage!.contains('Success')
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _uploadMessage!.contains('Success')
                          ? Icons.check_circle
                          : Icons.error,
                      color: _uploadMessage!.contains('Success')
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_uploadMessage!),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                icon: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.upload),
                label: Text(
                  _isUploading ? 'Uploading...' : 'Upload',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: _isUploading ||
                        _selectedDocType == null ||
                        _selectedFileName == null
                    ? null
                    : _uploadFile,
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isUploading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeOption({
    required String value,
    required String label,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedDocType == value;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(label),
      subtitle: Text(description),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedDocType,
        onChanged: (val) {
          setState(() => _selectedDocType = val);
        },
      ),
      onTap: () {
        setState(() => _selectedDocType = value);
      },
    );
  }

  Future<void> _selectFile() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select File'),
        content: const Text(
            'File picker dialog would appear here.\nFor demo, selecting: transcript.pdf'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFileName = 'transcript.pdf';
              });
              Navigator.pop(context);
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile() async {
    if (_selectedDocType == null ||
        _selectedFileName == null ||
        widget.studentId == null) {
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadMessage = null;
    });

    try {
      await Future.delayed(
        const Duration(seconds: 2),
      );

      print('File uploaded:');
      print('  Student ID: ${widget.studentId}');
      print('  Document Type: $_selectedDocType');
      print('  File Name: $_selectedFileName');

      setState(() {
        _uploadMessage = 'Success: File uploaded successfully!';
        _isUploading = false;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document uploaded successfully!'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
      });
    } catch (e) {
      setState(() {
        _uploadMessage = 'Error: Failed to upload file';
        _isUploading = false;
      });
    }
  }
}
