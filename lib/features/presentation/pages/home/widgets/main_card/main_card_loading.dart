import 'package:flutter/material.dart';

class MainCardLoading extends StatelessWidget {
  const MainCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: CircularProgressIndicator(
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}