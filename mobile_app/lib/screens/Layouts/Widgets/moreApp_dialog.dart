import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../services/moreApp/listApp.dart';
import '../../../services/moreApp/moreApp_service.dart';

class MoreAppsDialog extends StatefulWidget {
  const MoreAppsDialog({super.key});

  @override
  State<MoreAppsDialog> createState() => _MoreAppsDialogState();
}

class _MoreAppsDialogState extends State<MoreAppsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 20,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        constraints: const BoxConstraints(
          maxHeight: 450,
          maxWidth: 350,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 👉 Canh giữa cả nội dung
              children: [
                const Icon(
                  Icons.apps_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'More Applications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black45,
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.apps_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // List of apps
            Expanded(
              child: Scrollbar(
                thumbVisibility: false,
                radius: const Radius.circular(20),
                thickness: 6,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: similarApps.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final app = similarApps[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.deepPurple.withOpacity(0.15),
                          child: Icon(
                            Icons.book_online_rounded,
                            color: Colors.black38,
                            size: 30,
                          ),
                          // TODO: Thay bằng icon app thực nếu có
                        ),
                        title: Text(
                          app['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _storeButton(
                              icon: Icons.android,
                              color: Colors.green,
                              tooltip: 'Open Google Play',
                              onPressed: () => openGooglePlay(app['package']!),
                            ),
                            const SizedBox(width: 14),
                            _storeButton(
                              icon: Icons.apple,
                              color: Colors.lightBlueAccent,
                              tooltip: 'Open App Store',
                              onPressed: () => openAppStore(app['appstore_id']!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Close button big
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.deepPurple.withOpacity(0.5),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  S.of(context).close,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _storeButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          splashColor: color.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: color, size: 26),
          ),
        ),
      ),
    );
  }
}
