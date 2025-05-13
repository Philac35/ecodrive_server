class PriorityQueue<E> implements Iterable<E>{
  final List<E> _heap;
  final Comparator<E> _comparator;
  final Map<E, int> _elementToIndex;

  PriorityQueue(this._comparator)
      : _heap = [],
        _elementToIndex = {};

  int get length => _heap.length;

  bool get isEmpty => _heap.isEmpty;

  void add(E element) {
    _heap.add(element);
    _elementToIndex[element] = _heap.length - 1;
    _siftUp(_heap.length - 1);
  }

  E removeFirst() {
    if (isEmpty) throw StateError('PriorityQueue is empty');
    final first = _heap.first;
    _elementToIndex.remove(first);
    final last = _heap.removeLast();
    if (isEmpty) return first;
    _heap[0] = last;
    _elementToIndex[last] = 0;
    _siftDown(0);
    return first;
  }

  bool remove(E element) {
    if (!_elementToIndex.containsKey(element)) return false;
    final index = _elementToIndex[element]!;
    final last = _heap.removeLast();
    if (index != _heap.length) {
      _heap[index] = last;
      _elementToIndex[last] = index;
      if (_comparator(last, element) < 0) {
        _siftUp(index);
      } else {
        _siftDown(index);
      }
    }
    _elementToIndex.remove(element);
    return true;
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (var element in _heap) {
      if (test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw StateError('No element');
  }

  E get first => _heap.first;

  @override
  bool contains(Object? element) {
    if (element == null) return false;
    return _elementToIndex.containsKey(element);
  }

  void _siftUp(int index) {
    final element = _heap[index];
    while (index > 0) {
      final parentIndex = (index - 1) ~/ 2;
      final parent = _heap[parentIndex];
      if (_comparator(element, parent) >= 0) break;
      _heap[index] = parent;
      _elementToIndex[parent] = index;
      index = parentIndex;
    }
    _heap[index] = element;
    _elementToIndex[element] = index;
  }

  void _siftDown(int index) {
    final element = _heap[index];
    final length = _heap.length;
    while (true) {
      final leftChildIndex = 2 * index + 1;
      final rightChildIndex = 2 * index + 2;

      int firstIndex;
      if (rightChildIndex >= length) {
        if (leftChildIndex >= length) return;
        firstIndex = leftChildIndex;
      } else {
        final leftChild = _heap[leftChildIndex];
        final rightChild = _heap[rightChildIndex];
        firstIndex = _comparator(leftChild, rightChild) <= 0 ? leftChildIndex : rightChildIndex;
      }

      final first = _heap[firstIndex];
      if (_comparator(element, first) <= 0) break;

      _heap[index] = first;
      _elementToIndex[first] = index;
      index = firstIndex;
    }
    _heap[index] = element;
    _elementToIndex[element] = index;
  }

  @override
  Iterator<E> get iterator => _heap.iterator;

  @override
  bool any(bool Function(E element) test) => _heap.any(test);

  @override
  Iterable<R> cast<R>() => _heap.cast<R>();

  @override
  E elementAt(int index) => _heap.elementAt(index);

  @override
  bool every(bool Function(E element) test) => _heap.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) => _heap.expand(toElements);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) => _heap.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _heap.followedBy(other);

  @override
  void forEach(void Function(E element) action) => _heap.forEach(action);

  @override
  bool get isNotEmpty => _heap.isNotEmpty;

  @override
  String join([String separator = ""]) => _heap.join(separator);

  @override
  E get last => _heap.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) => _heap.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E e) toElement) => _heap.map(toElement);

  @override
  E reduce(E Function(E value, E element) combine) => _heap.reduce(combine);

  @override
  E get single => _heap.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) => _heap.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => _heap.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _heap.skipWhile(test);

  @override
  Iterable<E> take(int count) => _heap.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _heap.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => _heap.toList(growable: growable);

  @override
  Set<E> toSet() => _heap.toSet();

  @override
  Iterable<E> where(bool Function(E element) test) => _heap.where(test);

  @override
  Iterable<T> whereType<T>() => _heap.whereType<T>();


}
