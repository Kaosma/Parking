abstract interface class RepositoryInterface<T> {
  Future<T?> add(T item);
  Future<List<T>> getAll();
  Future<T?> update(String id, T item);
}
