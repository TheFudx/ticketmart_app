import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Official Phone.email OTP Authentication Popup Modal
///
/// Loads the official Phone.email login popup (client_id: 13889200858715854466)
/// which handles mobile number input, OTP delivery via WhatsApp/SMS,
/// and OTP verification directly within Phone.email's UI.
///
/// Returns the verified [accessToken] or [userJsonUrl] upon successful completion.
class PhoneEmailAuthDialog extends StatefulWidget {
  final String eventSlug;
  final String? prefilledPhone;
  final String clientId;

  const PhoneEmailAuthDialog({
    super.key,
    required this.eventSlug,
    this.prefilledPhone,
    this.clientId = '13889200858715854466',
  });

  /// Helper static method to show the Phone.email popup modal
  static Future<String?> show(
    BuildContext context, {
    required String eventSlug,
    String? prefilledPhone,
    String clientId = '13889200858715854466',
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (ctx) => PhoneEmailAuthDialog(
        eventSlug: eventSlug,
        prefilledPhone: prefilledPhone,
        clientId: clientId,
      ),
    );
  }

  @override
  State<PhoneEmailAuthDialog> createState() => _PhoneEmailAuthDialogState();
}

class _PhoneEmailAuthDialogState extends State<PhoneEmailAuthDialog> {
  late final WebViewController _controller;
  double _loadingProgress = 0.0;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasPopped = false;

  late final String _authUrl;

  @override
  void initState() {
    super.initState();

    final redirect = Uri.encodeComponent(
      'https://ticketmart.co/invite/${widget.eventSlug}',
    );

    // Build Phone.email official auth URL
    var url = 'https://auth.phone.email/log-in'
        '?client_id=${widget.clientId}'
        '&auth_type=1'
        '&redirect_url=$redirect';

    if (widget.prefilledPhone != null &&
        widget.prefilledPhone!.trim().isNotEmpty) {
      final cleanPhone = widget.prefilledPhone!.replaceAll(RegExp(r'\D'), '');
      if (cleanPhone.isNotEmpty) {
        url += '&user_phone_no=$cleanPhone';
      }
    }

    _authUrl = url;
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress / 100.0;
                if (progress >= 100) {
                  _isLoading = false;
                }
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
            _injectJsBridge();
            _checkUrlForToken(url);
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            _injectJsBridge();
            _checkUrlForToken(url);
          },
          onWebResourceError: (WebResourceError error) {
            // Filter out minor subresource errors
            if (error.isForMainFrame ?? true) {
              debugPrint('Phone.email WebView main frame error: ${error.description}');
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _errorMessage = error.description;
                  _isLoading = false;
                });
              }
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final handled = _checkUrlForToken(request.url);
            if (handled) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              _checkUrlForToken(change.url!);
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'PhoneEmailChannel',
        onMessageReceived: (JavaScriptMessage message) {
          _handleTokenResult(message.message);
        },
      )
      ..loadRequest(Uri.parse(_authUrl));
  }

  /// Inject JS bridge so Phone.email's completion triggers our channel
  void _injectJsBridge() {
    const js = '''
      (function() {
        if (!window.Android) {
          window.Android = {};
        }
        window.Android.sendTokenToApp = function(token) {
          try {
            PhoneEmailChannel.postMessage(token.toString());
          } catch(e) {}
        };

        if (!window.flutter_inappwebview) {
          window.flutter_inappwebview = {};
        }
        window.flutter_inappwebview.callHandler = function(handler, params) {
          try {
            var tok = '';
            if (typeof params === 'string') {
              tok = params;
            } else if (params && params.access_token) {
              tok = params.access_token;
            } else if (params && params.jwt) {
              tok = params.jwt;
            } else {
              tok = JSON.stringify(params);
            }
            PhoneEmailChannel.postMessage(tok);
          } catch(e) {}
        };

        window.addEventListener('message', function(event) {
          try {
            if (event.data && event.data.user_json_url) {
              PhoneEmailChannel.postMessage(event.data.user_json_url.toString());
            } else if (event.data && event.data.access_token) {
              PhoneEmailChannel.postMessage(event.data.access_token.toString());
            }
          } catch(e) {}
        });
      })();
    ''';
    _controller.runJavaScript(js).catchError((_) {});
  }

  /// Check redirected or updated URLs for token query parameters
  bool _checkUrlForToken(String url) {
    try {
      final uri = Uri.parse(url);

      final accessToken = uri.queryParameters['access_token'];
      if (accessToken != null && accessToken.isNotEmpty) {
        _handleTokenResult(accessToken);
        return true;
      }

      final userJsonUrl = uri.queryParameters['user_json_url'];
      if (userJsonUrl != null && userJsonUrl.isNotEmpty) {
        _handleTokenResult(userJsonUrl);
        return true;
      }

      final phtoken = uri.queryParameters['phtoken'] ?? uri.queryParameters['token'];
      if (phtoken != null && phtoken.isNotEmpty && !phtoken.startsWith('http')) {
        _handleTokenResult(phtoken);
        return true;
      }
    } catch (e) {
      debugPrint('Error inspecting URL for Phone.email token: $e');
    }
    return false;
  }

  void _handleTokenResult(String token) {
    if (_hasPopped || !mounted) return;
    _hasPopped = true;
    Navigator.of(context).pop(token);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final targetHeight = (screenHeight * 0.88).clamp(520.0, 780.0);

    return Container(
      height: targetHeight + (keyboardHeight > 0 ? 40.h : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Drag Handle & Header ──────────────────────────────────
          Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
            child: Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),

          // Header Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              children: [
                // Phone.email brand icon
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF02BD7E).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user_rounded,
                    size: 20.sp,
                    color: const Color(0xFF02BD7E),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Phone.email",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF02BD7E).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              "OFFICIAL",
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF02BD7E),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Secure OTP Authentication",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Refresh Button
                IconButton(
                  onPressed: () {
                    _controller.reload();
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 20.sp,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Reload',
                ),

                // Close Button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          // Loading Progress Bar
          if (_isLoading)
            LinearProgressIndicator(
              value: _loadingProgress > 0 ? _loadingProgress : null,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF02BD7E)),
              minHeight: 2.5.h,
            )
          else
            Divider(height: 1, color: Colors.grey.shade200),

          // ── WebView Body ──────────────────────────────────────────
          Expanded(
            child: ClipRRect(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),

                  // Loading Overlay
                  if (_isLoading && _loadingProgress < 0.6)
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 36.r,
                              height: 36.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF02BD7E),
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              "Connecting to Phone.email...",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Instant OTP login via WhatsApp & SMS",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Error Overlay
                  if (_hasError)
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(24.r),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off_rounded,
                              size: 48.sp,
                              color: Colors.orange.shade600,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Unable to Load Phone.email",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _errorMessage ??
                                  "Please check your internet connection and try again.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _hasError = false;
                                  _isLoading = true;
                                });
                                _controller.loadRequest(Uri.parse(_authUrl));
                              },
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              label: const Text(
                                "Retry Connection",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
