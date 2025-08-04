/// Centralized error messages and user-facing text.
/// 
/// All error messages, success messages, and user notifications
/// are defined here to maintain consistency across the app.
class AppMessages {
  // Private constructor to prevent instantiation
  AppMessages._();
  
  //* GENERIC ERROR MESSAGES
  static const String timeoutError = 'La solicitud tardó demasiado. Intente nuevamente.';
  static const String noInternetConnection = 'Sin conexión a internet';
  
  //*  AUTHENTICATION MESSAGES
  static const String passwordRequired = 'La contraseña es requerida';
  static const String passwordMinLength = 'La contraseña debe tener al menos 8 caracteres';
  static const String passwordUppercase = 'Debe contener al menos una mayúscula';
  static const String passwordLowercase = 'Debe contener al menos una minúscula';
  static const String passwordNumber = 'Debe contener al menos un número';
  static const String passwordSpecialChar = 'Debe contener al menos un carácter especial';
  
  //*  VALIDATION MESSAGES
  static const String requerido = 'Requerido';
  static const String minChar = 'Mínimo de caracteres';
  static const String invalidDate = 'Fecha inválida';
  static const String invalidEmail = 'Ingrese un email válido';
  static const String invalidNumeric = 'Solo se permiten números';
  static const String invalidAlphanumeric = 'Solo se permiten letras y números';
  
  //*  PERMISSION MESSAGES
  static const String microphonePermissionDenied = 'Se requiere acceso al micrófono para esta función';
  static const String contactsPermissionDenied = 'Se requiere acceso a los contactos para esta función';
  
  //*  SUCCESS MESSAGES
  static const String copiedToClipboard = 'Copiado al portapapeles';
  static const String operationSuccessful = 'Operación exitosa';
  static const String changesApplied = 'Cambios aplicados';
  
  //*  WARNING MESSAGES
  static const String actionCannotBeUndone = 'Esta acción no se puede deshacer';
  static const String dataWillBeLost = 'Se perderán todos los datos no guardados';
  
  //*  LOADING MESSAGES
  static const String uploading = 'Subiendo...';
  static const String downloading = 'Descargando...';
  static const String syncing = 'Sincronizando...';
  
  //*  EMPTY STATE MESSAGES
  static const String noItemsToShow = 'No hay elementos para mostrar';
  static const String searchNoResults = 'No se encontraron resultados para su búsqueda';
  
  //*  ACTION LABELS
  static const String skip = 'Omitir';
  static const String yes = 'Sí';
  static const String no = 'No';
  
  //*  FILE MESSAGES
  static const String fileUploadError = 'Error al subir el archivo';
  static const String fileDownloadError = 'Error al descargar el archivo';
  
  //*  PAYMENT MESSAGES
  static const String cardDeclined = 'Tarjeta rechazada';
  static const String invalidCardNumber = 'Número de tarjeta inválido';
  static const String cardExpired = 'Tarjeta expirada';

  //* Texts
  static const String disponible = 'Disponible';
  static const String desconectado = 'Desconectado';
  
  //*  HELPER METHODS
  /// Returns a custom error message with field name
  static String fieldError(String fieldName, String error) {
    return '$fieldName: $error';
  }
  
  /// Returns a custom required field message
  static String requiredField(String fieldName) {
    return '$fieldName es requerido';
  }
  
  /// Returns a custom success message with action
  static String actionSuccess(String action, String item) {
    return '$item $action exitosamente';
  }
  
  /// Returns a custom confirmation message
  static String confirmAction(String action, String item) {
    return '¿Está seguro que desea $action $item?';
  }
}