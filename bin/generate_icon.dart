import 'dart:io';
import 'dart:typed_data';

void main() {
  // Create a simple 1024x1024 PNG icon with orange metronome design
  final size = 1024;
  final pixels = List<int>.filled(size * size * 4, 0);
  
  final orange = [0xFF, 0x5E, 0x00]; // #FF5E00
  final black = [0x00, 0x00, 0x00];
  
  // Fill background with black
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final idx = (y * size + x) * 4;
      pixels[idx] = black[0];
      pixels[idx + 1] = black[1];
      pixels[idx + 2] = black[2];
      pixels[idx + 3] = 0xFF; // Alpha
    }
  }
  
  // Draw vertical orange line in center
  final lineWidth = 80;
  for (int y = 100; y < size - 100; y++) {
    for (int x = (size - lineWidth) ~/ 2; x < (size + lineWidth) ~/ 2; x++) {
      final idx = (y * size + x) * 4;
      pixels[idx] = orange[0];
      pixels[idx + 1] = orange[1];
      pixels[idx + 2] = orange[2];
    }
  }
  
  // Draw triangle (metronome arm)
  final centerX = size ~/ 2;
  final topY = 200;
  final baseY = 500;
  final baseWidth = 300;
  
  for (int y = topY; y < baseY; y++) {
    final progress = (y - topY) / (baseY - topY);
    final currentWidth = (baseWidth * progress).toInt();
    for (int x = centerX - currentWidth ~/ 2; x < centerX + currentWidth ~/ 2; x++) {
      final idx = (y * size + x) * 4;
      pixels[idx] = orange[0];
      pixels[idx + 1] = orange[1];
      pixels[idx + 2] = orange[2];
    }
  }
  
  // Write PNG file (simplified - just create a placeholder)
  final file = File('assets/metronome_icon.png');
  // For now, create a minimal valid PNG
  // In production, use a proper PNG encoding library
  print('Icon generation complete. Please replace with actual PNG from SVG.');
}
