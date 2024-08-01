import 'package:flutter/material.dart';

class TypeBadge extends StatelessWidget {
  final String type;

  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: getTypeColor(type),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getTypeIcon(type),
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            type,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  static Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal': return Colors.brown[400]!;
      case 'fire': return Colors.red;
      case 'water': return Colors.blue;
      case 'electric': return Colors.yellow[700]!;
      case 'grass': return Colors.green;
      case 'ice': return Colors.cyan;
      case 'fighting': return Colors.orange[800]!;
      case 'poison': return Colors.purple;
      case 'ground': return Colors.brown;
      case 'flying': return Colors.indigo[200]!;
      case 'psychic': return Colors.pink;
      case 'bug': return Colors.lightGreen[500]!;
      case 'rock': return Colors.grey;
      case 'ghost': return Colors.indigo[400]!;
      case 'dragon': return Colors.indigo;
      case 'dark': return Colors.grey[800]!;
      case 'steel': return Colors.blueGrey;
      case 'fairy': return Colors.pinkAccent[100]!;
      default: return Colors.grey;
    }
  }

  static IconData getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'normal': return Icons.circle_outlined;
      case 'fire': return Icons.local_fire_department;
      case 'water': return Icons.water_drop;
      case 'electric': return Icons.flash_on;
      case 'grass': return Icons.grass;
      case 'ice': return Icons.ac_unit;
      case 'fighting': return Icons.sports_martial_arts;
      case 'poison': return Icons.science;
      case 'ground': return Icons.landscape;
      case 'flying': return Icons.air;
      case 'psychic': return Icons.psychology;
      case 'bug': return Icons.bug_report;
      case 'rock': return Icons.terrain;
      case 'ghost': return Icons.visibility_off;
      case 'dragon': return Icons.auto_fix_high;
      case 'dark': return Icons.nightlight_round;
      case 'steel': return Icons.shield;
      case 'fairy': return Icons.auto_awesome;
      default: return Icons.help_outline;
    }
  }
}