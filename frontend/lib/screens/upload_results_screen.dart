import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_constants.dart';

class UploadResultsScreen extends StatefulWidget {
  const UploadResultsScreen({Key? key}) : super(key: key);

  @override
  State<UploadResultsScreen> createState() => _UploadResultsScreenState();
}

class _UploadResultsScreenState extends State<UploadResultsScreen> {
  String? _selectedDocumentType;
  String? _selectedFileName;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  final List<String> _documentTypes = [
    AppConstants.docTypeTranscript,
    AppConstants.docTypeReportCard,
    AppConstants.docTypeCertificate,
  ];

  Future<void> _pickFile() async {
    // TODO: Implement file picker
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select File'),
        content: const Text('File picker will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _selectedFileName = 'sample_transcript.pdf');
              Navigator.pop(context);
            },
            child: const Text('Use Sample'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadDocument() async {
    if (_selectedDocumentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select document type')),
      );
      return;
    }

    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Simulate upload with progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() => _uploadProgress = i / 100);
      }

      // TODO: Call student service to upload document
      // final document = await _studentService.uploadDocument(
      //   studentId: studentId,
      //   documentType: _selectedDocumentType!,
      //   filePath: filePath,
      //   fileName: _selectedFileName!,
      // );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document uploaded successfully!')),
      );

      // Reset form
      setState(() {
        _selectedDocumentType = null;
        _selectedFileName = null;
        _uploadProgress = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Results'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Upload Academic Documents',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Help us understand your academic performance better',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),

            // Document Type Selection
            Text(
              'Document Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            ..._documentTypes.map((type) {
              final isSelected = _selectedDocumentType == type;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  child: InkWell(
                    onTap: () => setState(() => _selectedDocumentType = type),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.05)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getDocumentLabel(type),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getDocumentDescription(type),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),

            // File Upload Section
            Text(
              'Select File',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _FileUploadBox(
              fileName: _selectedFileName,
              onTap: _isUploading ? null : _pickFile,
            ),
            const SizedBox(height: 32),

            // Upload Progress
            if (_isUploading) ...[
              Text(
                'Uploading...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
            ],

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadDocument,
                child: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Upload Document'),
              ),
            ),
            const SizedBox(height: 16),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'File Requirements',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.info,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Max 5MB • PDF, JPG, PNG formats only',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDocumentLabel(String type) {
    switch (type) {
      case 'transcript':
        return 'Transcript';
      case 'report_card':
        return 'Report Card';
      case 'certificate':
        return 'Certificate';
      default:
        return type;
    }
  }

  String _getDocumentDescription(String type) {
    switch (type) {
      case 'transcript':
        return 'Your official academic transcript';
      case 'report_card':
        return 'Your school report card';
      case 'certificate':
        return 'Achievement or course certificate';
      default:
        return '';
    }
  }
}

class _FileUploadBox extends StatelessWidget {
  final String? fileName;
  final VoidCallback? onTap;

  const _FileUploadBox({
    this.fileName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
          ),
          child: Column(
            children: [
              if (fileName == null)
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: AppColors.primary,
                )
              else
                Icon(
                  Icons.insert_drive_file,
                  size: 48,
                  color: AppColors.success,
                ),
              const SizedBox(height: 16),
              Text(
                fileName ?? 'Tap to upload a file',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: fileName == null ? Colors.grey[600] : null,
                    ),
              ),
              if (fileName == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'or drag and drop',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
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
