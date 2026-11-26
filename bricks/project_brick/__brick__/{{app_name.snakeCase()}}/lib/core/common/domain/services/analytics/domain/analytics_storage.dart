/// Encrypted key/value storage the analytics queue and identity persist in.
abstract interface class IAnalyticsStorage {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
  Future<List<String>> keys();
}
