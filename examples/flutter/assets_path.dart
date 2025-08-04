/// Centralized asset paths for the application.
/// 
/// All asset paths are defined here to maintain consistency
/// and enable easy asset management across the app.
class Assets {
  // Private constructor to prevent instantiation
  Assets._();
  
  //*  BASE PATHS
  static const String _baseImages = 'assets/images';
  static const String _baseIcons = 'assets/icons';
  static const String _baseAnimations = 'assets/animations';
  static const String _baseSounds = 'assets/sounds';
  
  //*  IMAGES - LOGOS & BRANDING
  static const String logo = '$_baseImages/logo/logo.png';
  static const String logoSmall = '$_baseImages/logo/logo_small.png';
  static const String splash = '$_baseImages/logo/splash.png';
  
  //*  IMAGES - ONBOARDING
  static const String onboarding1 = '$_baseImages/onboarding/onboarding_1.png';
  
  //*  IMAGES - BACKGROUNDS
  static const String backgroundPattern = '$_baseImages/backgrounds/pattern.png';
  
  //*  IMAGES - PLACEHOLDERS
  static const String placeholderUser = '$_baseImages/placeholders/user.png';
  static const String placeholderImage = '$_baseImages/placeholders/image.png';
  
  //*  IMAGES - ILLUSTRATIONS
  static const String emptyState = '$_baseImages/illustrations/empty_state.png';
  
  //*  SVG ICONS
  static const String iconHome = '$_baseIcons/home.svg';
  static const String iconProfile = '$_baseIcons/profile.svg';
  
  //*  CATEGORY ICONS
  static const String categoryFood = '$_baseIcons/categories/food.svg';
  static const String categoryClothes = '$_baseIcons/categories/clothes.svg';
  
  //*  LOTTIE ANIMATIONS
  static const String animationLoading = '$_baseAnimations/loading.json';
  static const String animationSuccess = '$_baseAnimations/success.json';
  static const String animationError = '$_baseAnimations/error.json';
  
  //*  SOUNDS
  static const String soundNotification = '$_baseSounds/notification.mp3';
  static const String soundSuccess = '$_baseSounds/success.mp3';
  
  //*  FONTS
  static const String fontPrimary = 'Roboto';
  static const String fontSecondary = 'OpenSans';
  
  //*  HELPER METHODS
  /// Returns the path for a user avatar
  static String userAvatar(String userId) {
    return '$_baseImages/users/avatar_$userId.jpg';
  }
  
  /// Returns the path for a product image
  static String productImage(String productId) {
    return '$_baseImages/products/product_$productId.jpg';
  }
  
  /// Returns the path for a category icon
  static String categoryIcon(String category) {
    return '$_baseIcons/categories/${category.toLowerCase()}.svg';
  }
  
  /// Returns the path for a flag icon
  static String flagIcon(String countryCode) {
    return '$_baseIcons/flags/${countryCode.toLowerCase()}.svg';
  }
}