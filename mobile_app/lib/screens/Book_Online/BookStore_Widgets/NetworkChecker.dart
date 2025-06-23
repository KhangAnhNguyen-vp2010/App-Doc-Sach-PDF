import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/screens/Common_Widgets/Loading/LoadingOverlay.dart';
import 'package:mobile_app/services/api/api_urls.dart';
import 'package:provider/provider.dart';

import '../../../Providers/ThemeProvider.dart';
import '../../../generated/l10n.dart';
import '../../../services/WiFiCheck/internetCheck.dart';

typedef DataFetcher = Future<void> Function();

class NetworkChecker extends StatefulWidget {
  final DataFetcher onFetchData;
  final Widget child;

  const NetworkChecker({
    super.key,
    required this.onFetchData,
    required this.child,
  });

  @override
  State<NetworkChecker> createState() => _NetworkCheckerState();
}

class _NetworkCheckerState extends State<NetworkChecker> {
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndFetch();
  }

  Future<void> _checkAndFetch() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });

    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/Sach'))
          .timeout(const Duration(seconds: 5)); // timeout sau 5 giây
      if (response.statusCode != 200) {
        throw Exception('Server không phản hồi đúng');
      }
      await widget.onFetchData();
    } on TimeoutException catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    if (_isLoading) {
      return const Center(
        child: LoadingOverlay(),
      );
    }

    if (_hasError) {
      return Container(
        color: isDark ? Colors.black87 : Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: Colors.redAccent, size: 64),
                const SizedBox(height: 16),
                Text(
                  '${S.of(context).thereWasAProblemConnecting}!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  '${S.of(context).thereWasAProblemLoadingData}!.\n${S.of(context).pleaseCheckYourNetworkOrTryAgainLater}.',
                  style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _checkAndFetch,
                  icon: const Icon(Icons.refresh),
                  label: Text(S.of(context).reLoad),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
