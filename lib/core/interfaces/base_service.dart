abstract class BaseService {
  Future<void> initialize();
  Future<void> dispose();
  bool get isInitialized;
}