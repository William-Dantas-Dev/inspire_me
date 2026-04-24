import 'package:flutter/material.dart';

class FavoritesRemovalController {
  FavoritesRemovalController({
    required this.messenger,
    required this.removedMessage,
    required this.undoLabel,
    required this.onPending,
    required this.onUndo,
    required this.onRemove,
  });

  final ScaffoldMessengerState messenger;
  final String removedMessage;
  final String undoLabel;
  final VoidCallback onPending;
  final VoidCallback onUndo;
  final Future<void> Function(int id) onRemove;

  bool _cancelled = false;

  Future<void> start(int id) async {
    _cancelled = false;

    onPending();
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(removedMessage),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: undoLabel,
          onPressed: () {
            _cancelled = true;
            onUndo();
            messenger.clearSnackBars();
          },
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (_cancelled) return;

    await onRemove(id);

    messenger.clearSnackBars();
  }
}
