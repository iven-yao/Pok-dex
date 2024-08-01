import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedexapp/components/type_badge.dart';

class PokemonMainImage extends StatelessWidget {
  final String imageUrl;
  final String type1;
  final String? type2;

  const PokemonMainImage({
    super.key,
    required this.imageUrl,
    required this.type1,
    this.type2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: BackgroundClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TypeBadge.getTypeColor(type1),
                      type2 != null ? TypeBadge.getTypeColor(type2!) : TypeBadge.getTypeColor(
                          type1).withOpacity(0.7),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: BackgroundPatternPainter(type1),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Hero(
                tag: imageUrl,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  height: 200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 50);
    path.quadraticBezierTo(size.width / 3, size.height, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BackgroundPatternPainter extends CustomPainter {
  final String type;

  BackgroundPatternPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    switch (type.toLowerCase()) {
      case 'fire':
        _drawFirePattern(canvas, size, paint);
        break;
      case 'water':
        _drawWaterPattern(canvas, size, paint);
        break;
      case 'grass':
        _drawGrassPattern(canvas, size, paint);
        break;
    // Will add more cases for other types
      default:
        _drawDefaultPattern(canvas, size, paint);
    }
  }

  void _drawFirePattern(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < 5; i++) {
      final path = Path();
      path.moveTo(size.width * (i / 5), 0);
      path.quadraticBezierTo(
        size.width * ((i + 0.5) / 5),
        size.height * 0.5,
        size.width * ((i + 1) / 5),
        size.height,
      );
      canvas.drawPath(path, paint);
    }
  }

  void _drawWaterPattern(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(size.width * (i / 5), size.height * (0.5 + (i % 2) * 0.2)),
        size.width * 0.1,
        paint,
      );
    }
  }

  void _drawGrassPattern(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        final path = Path();
        path.moveTo(size.width * (i / 3), size.height * (j / 2));
        path.lineTo(size.width * ((i + 0.5) / 3), size.height * ((j + 0.5) / 2));
        path.lineTo(size.width * ((i + 1) / 3), size.height * (j / 2));
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawDefaultPattern(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width * (i / 4), 0),
        Offset(size.width * (i / 4), size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, size.height * (i / 4)),
        Offset(size.width, size.height * (i / 4)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}