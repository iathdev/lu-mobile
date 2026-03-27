import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lu_mobile/core/network/providers.dart';
import 'package:lu_mobile/core/theme/app_colors.dart';
import 'package:lu_mobile/core/theme/app_spacing.dart';
import 'package:lu_mobile/core/widgets/quota_badge.dart';
import 'package:lu_mobile/features/ocr/data/models/ocr_result_model.dart';
import 'package:lu_mobile/features/ocr/data/repositories/ocr_repository.dart';
import 'package:lu_mobile/features/ocr/presentation/pages/ocr_preview_page.dart';

class OcrCameraPage extends ConsumerStatefulWidget {
  const OcrCameraPage({super.key});

  @override
  ConsumerState<OcrCameraPage> createState() => _OcrCameraPageState();
}

class _OcrCameraPageState extends ConsumerState<OcrCameraPage> {
  final _picker = ImagePicker();
  bool _isScanning = false;
  Uint8List? _selectedImageBytes;
  String? _errorMessage;

  Future<void> _pickAndScan(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        imageQuality: 85,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      final fileName = image.name;

      setState(() {
        _selectedImageBytes = bytes;
        _isScanning = true;
        _errorMessage = null;
      });

      final client = ref.read(apiClientProvider);
      final repo = OcrRepository(client);

      final result = await repo.scan(
        imageBytes: bytes,
        fileName: fileName,
        type: 'auto',
        language: 'zh',
      );

      if (!mounted) return;
      setState(() => _isScanning = false);
      _navigateToPreview(result);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _navigateToPreview(OcrScanResult result) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OcrPreviewPage(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Scan'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: QuotaBadge(used: 0, limit: 3, label: 'Scans'),
          ),
        ],
      ),
      body: _isScanning ? _buildScanning() : _buildOptions(),
    );
  }

  Widget _buildScanning() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedImageBytes != null) ...[
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusMd,
              child: Image.memory(
                _selectedImageBytes!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Scanning for Chinese characters...',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Text('Sending image to OCR engine...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        children: [
          const Spacer(),

          // Error message
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusSm,
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(_errorMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Illustration
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.document_scanner_outlined,
                    size: 64, color: AppColors.primary.withValues(alpha: 0.6)),
                const SizedBox(height: AppSpacing.md),
                Text('Scan Chinese characters',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Take a photo or select from gallery\nto detect Chinese characters via OCR',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: AppColors.primary,
                  onTap: () => _pickAndScan(ImageSource.camera),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ActionButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: AppColors.info,
                  onTap: () => _pickAndScan(ImageSource.gallery),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Info
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Row(children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Image is uploaded to the Go backend OCR engine for processing',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ]),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: AppSpacing.borderRadiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: AppSpacing.sm),
            Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color)),
          ]),
        ),
      ),
    );
  }
}
