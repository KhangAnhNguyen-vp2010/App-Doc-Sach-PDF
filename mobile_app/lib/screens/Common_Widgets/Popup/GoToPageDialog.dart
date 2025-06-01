// widgets/goto_page_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Providers/ThemeProvider.dart';
import '../../../generated/l10n.dart';

class GoToPageDialog extends StatefulWidget {
  final int totalPages;
  final Function(int) onGoToPage;

  const GoToPageDialog({
    super.key,
    required this.totalPages,
    required this.onGoToPage,
  });

  @override
  State<GoToPageDialog> createState() => _GoToPageDialogState();
}

class _GoToPageDialogState extends State<GoToPageDialog> {
  final TextEditingController _pageController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _validateAndGoToPage() {
    final pageText = _pageController.text.trim();

    if (pageText.isEmpty) {
      setState(() => _errorText = S.of(context).pleaseEnterPageNumber);
      return;
    }

    final pageNumber = int.tryParse(pageText);

    if (pageNumber == null) {
      setState(() => _errorText = S.of(context).invalidPageNumber);
      return;
    }

    if (pageNumber < 1 || pageNumber > widget.totalPages) {
      setState(() => _errorText = '${S.of(context).pageNumberMustBeFrom1To} ${widget.totalPages}');
      return;
    }

    Navigator.pop(context);
    widget.onGoToPage(pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return AlertDialog(
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTextField(),
          const SizedBox(height: 24),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.skip_next_rounded,
                color: Colors.blue[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).goToPage,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${S.of(context).theDocumentHasATotalOf} ${widget.totalPages} ${S.of(context).page}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).page,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _errorText != null ? Colors.red : Colors.grey[200]!,
            ),
          ),
          child: TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: '${S.of(context).enterANumberFrom1To} ${widget.totalPages}',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: (value) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
            onSubmitted: (_) => _validateAndGoToPage(),
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildButtons() {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _validateAndGoToPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              S.of(context).goTo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}