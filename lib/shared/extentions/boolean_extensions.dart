extension OptionalBoolExtensions on bool? {
  bool get isNotNullNorFalse => this != null && this!;

  bool get isNullOrFalse => this == null || !this!;
}
