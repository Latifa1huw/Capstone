

extension OptionalStringExtensions on String? {
  bool get isNullOrEmptyOrFalse =>
      (this?.isEmpty ?? true) || this?.toLowerCase() == 'null' || this == 'false' || this!.trim().isEmpty;

  bool get isNotNullNorEmptyOrTrue => (this?.isNotEmpty ?? false) && this?.toLowerCase() != 'null' && this != 'false';

  bool get isNullOrEmpty => (this?.isEmpty ?? true) || this?.toLowerCase() == 'null' || this!.trim().isEmpty;

  bool get isNotNullNorEmpty => (this?.isNotEmpty ?? false) && this?.toLowerCase() != 'null';

  String ellipsis({required int maxLength}) =>
      isNotNullNorEmpty ? (this!.length >= maxLength ? '${this!.substring(0, maxLength)}...' : this!) : '';

  String reverseText([String identifier = '']) {
    return this!.split(identifier).reversed.join(identifier);
  }
}
