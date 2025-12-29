/// Form validation utilities.
class Validators {
  Validators._();

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  /// Validate password (minimum 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validate password with strength requirements
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validate confirm password matches password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate display name (2-50 characters)
  static String? validateDisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }

    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, [String fieldName = 'Value']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }

    return null;
  }

  /// Validate integer in range
  static String? validateIntInRange(
    String? value, {
    required int min,
    required int max,
    String fieldName = 'Value',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }

    return null;
  }

  /// Validate weight (reasonable gym weights)
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Weight can be optional (bodyweight exercises)
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }

    if (weight < 0) {
      return 'Weight cannot be negative';
    }

    if (weight > 2000) {
      return 'Please enter a reasonable weight';
    }

    return null;
  }

  /// Validate reps (1-999)
  static String? validateReps(String? value) {
    if (value == null || value.isEmpty) {
      return 'Reps required';
    }

    final reps = int.tryParse(value);
    if (reps == null) {
      return 'Invalid number';
    }

    if (reps < 1 || reps > 999) {
      return 'Enter 1-999';
    }

    return null;
  }

  /// Validate sets (1-99)
  static String? validateSets(String? value) {
    if (value == null || value.isEmpty) {
      return 'Sets required';
    }

    final sets = int.tryParse(value);
    if (sets == null) {
      return 'Invalid number';
    }

    if (sets < 1 || sets > 99) {
      return 'Enter 1-99';
    }

    return null;
  }
}
