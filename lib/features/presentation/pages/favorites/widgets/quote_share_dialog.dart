import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../application/share/share_card_service.dart';
import '../../../../application/share/share_message_builder.dart';
import 'shareable_quote_card.dart';

class QuoteShareDialog extends ConsumerStatefulWidget {
  const QuoteShareDialog({
    super.key,
    required this.quoteText,
    required this.author,
    required this.tags,
    required this.category,
  });

  final String quoteText;
  final String author;
  final List<String> tags;
  final int category;

  @override
  ConsumerState<QuoteShareDialog> createState() => _QuoteShareDialogState();
}

class _QuoteShareDialogState extends ConsumerState<QuoteShareDialog> {
  final GlobalKey _previewKey = GlobalKey();

  final ShareCardService _shareCardService = const ShareCardService();
  final ShareMessageBuilder _shareMessageBuilder = const ShareMessageBuilder();

  bool _isSharing = false;

  Future<void> _sharePreviewAsImage() async {
    if (_isSharing) return;

    final previewContext = _previewKey.currentContext;
    final l10n = AppLocalizations.of(context)!;

    if (previewContext == null) return;

    final renderObject = previewContext.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      return;
    }

    setState(() {
      _isSharing = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final shareText = _shareMessageBuilder.build(
        appName: l10n.appName,
        quoteText: widget.quoteText,
        author: widget.author,
      );

      await _shareCardService.shareRepaintBoundary(
        boundary: renderObject,
        fileName: 'quote.png',
        text: shareText,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      debugPrint('Erro ao compartilhar preview: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.shareImageError)));
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: _previewKey,
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: 320,
                    child: ShareableQuoteCard(
                      quoteText: widget.quoteText,
                      author: widget.author,
                      tags: widget.tags,
                      category: widget.category,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSharing
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isSharing ? null : _sharePreviewAsImage,
                      icon: _isSharing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.share_rounded),
                      label: Text(_isSharing ? l10n.sharing : l10n.share),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
