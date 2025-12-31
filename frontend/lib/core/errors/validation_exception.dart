class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>> errors;

  ValidationException({
    required this.message,
    required this.errors,
  });

  factory ValidationException.fromJson(Map<String, dynamic> json) {
    return ValidationException(
      message: json['message'],
      errors: Map<String, List<String>>.from(
        json['errors'].map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
    );
  }
}
