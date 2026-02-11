abstract class BaseRepository<T, ID> {
  Future<List<T>> getAll();
  Future<T?> getById(ID id);
  Future<T> create(T entity);
  Future<T> update(T entity);
  Future<bool> delete(ID id);
  Future<bool> exists(ID id);
}