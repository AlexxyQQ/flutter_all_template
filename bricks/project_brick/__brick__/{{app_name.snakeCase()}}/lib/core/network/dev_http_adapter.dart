import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../config/env/app_env.dart';

/// Debug-only HTTP client tweaks for local development:
///
/// * `DEV_PROXY=host:port` routes traffic through a proxy (Charles, mitmproxy).
/// * `DEV_TRUST_SELF_SIGNED_CERTS=true` accepts self-signed certificates for
///   the **API host only**.
///
/// Both are ignored unless `kDebugMode` is true, so a misconfigured release
/// pipeline can never ship a client that trusts arbitrary certificates.
HttpClientAdapter? createDevHttpClientAdapter({required String baseUrl}) {
  if (!kDebugMode) {
    return null;
  }
  const proxy = AppEnv.devProxy;
  const trustSelfSigned = AppEnv.devTrustSelfSignedCerts;
  if (proxy.isEmpty && !trustSelfSigned) {
    return null;
  }
  final apiHost = Uri.tryParse(baseUrl)?.host.toLowerCase();

  return IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      if (proxy.isNotEmpty) {
        client.findProxy = (_) => 'PROXY $proxy';
      }
      if (trustSelfSigned) {
        client.badCertificateCallback = (cert, host, port) =>
            apiHost != null && host.toLowerCase() == apiHost;
      }
      return client;
    },
  );
}
