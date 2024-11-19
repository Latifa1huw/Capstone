extension ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension OptionalListExtensions on List? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  bool get isNotNullNorEmpty => this?.isNotEmpty ?? false;

  bool get isMoreThanOne => isNotNullNorEmpty && this!.length > 1;
}
