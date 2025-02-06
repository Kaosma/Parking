abstract interface class RepositoryInterface<T> {
  Future<T?> add(T item);
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<T?> update(T item);
  Future<void> delete(T item);
}
