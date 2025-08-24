class AppValidator{

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 4) return 'Name must be at least 4 characters';

    return null;
  }

  static String? validateDesc(String? value) {
    if (value == null || value.isEmpty) return 'Description is required';
    if (value.length < 6) return 'Description must be at least 6 characters';
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Title is required';
    if (value.length < 4) return 'Title must be at least 4 characters';
    return null;
  }

}