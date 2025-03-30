import 'dart:math';

class NumberFormatter {
  /// Format large numbers into scientific notation (e.g. 1.23e6)
  /// 
  /// Parameters:
  ///   number - The number to format
  ///   decimals - Number of decimal places to show (default: 2)
  ///   minThreshold - Minimum value to trigger scientific notation (default: 1000000)
  static String formatScientific(double number, {int decimals = 2, double minThreshold = 1000000}) {
    // Handle small numbers normally
    if (number.abs() < minThreshold) {
      return number.toStringAsFixed(decimals);
    }
    
    // Calculate exponent and mantissa
    final int exp = (log(number.abs()) / ln10).floor();
    final double mantissa = number / pow(10, exp);
    
    // Format with proper decimal places
    return '${mantissa.toStringAsFixed(decimals)}e$exp';
  }
  
  /// Format numbers into compact notation with suffixes (K, M, B, T, etc.)
  /// 
  /// Parameters:
  ///   number - The number to format
  ///   decimals - Number of decimal places to show (default: 1)
  static String formatCompact(double number, {int decimals = 1}) {
    if (number.abs() < 1000) {
      return number.toStringAsFixed(0); // No decimals for small numbers
    }
    
    const List<String> suffixes = ['', 'K', 'M', 'B', 'T', 'Qa', 'Qi', 'Sx', 'Sp', 'Oc', 'No', 'Dc'];
    final int tier = (log(number.abs()) / ln10 / 3).floor();
    
    // Ensure we don't go out of bounds of our suffixes array
    final int maxTier = suffixes.length - 1;
    final int safeTier = tier > maxTier ? maxTier : tier;
    
    final double scaled = number / pow(10, safeTier * 3);
    final String suffix = suffixes[safeTier];
    
    return '${scaled.toStringAsFixed(decimals)}$suffix';
  }
}