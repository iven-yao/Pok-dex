import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pokedexapp/models/pokemon_model.dart';

class PokemonStatsChart extends StatelessWidget {
  final PokemonModel pokemon;

  const PokemonStatsChart({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Stats Chart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 255, // Maximum stat value in Pokemon games
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getTitles,
                      reservedSize: 60, // Increased to accommodate stat values
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 65,
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 65
                    )),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  makeGroupData(0, pokemon.hp, Colors.red),
                  makeGroupData(1, pokemon.attack, Colors.orange),
                  makeGroupData(2, pokemon.defense, Colors.yellow),
                  makeGroupData(3, pokemon.special_attack, Colors.blue),
                  makeGroupData(4, pokemon.special_defense, Colors.green),
                  makeGroupData(5, pokemon.speed, Colors.purple),
                ],
              ),
            ),
          )
        ]
    );
  }

  BarChartGroupData makeGroupData(int x, int y, Color barColor) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: barColor,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const statNameStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const statValueStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    String statName;
    int statValue;

    switch (value.toInt()) {
      case 0:
        statName = 'HP';
        statValue = pokemon.hp;
        break;
      case 1:
        statName = 'Atk';
        statValue = pokemon.attack;
        break;
      case 2:
        statName = 'Def';
        statValue = pokemon.defense;
        break;
      case 3:
        statName = 'Sp.Atk';
        statValue = pokemon.special_attack;
        break;
      case 4:
        statName = 'Sp.Def';
        statValue = pokemon.special_defense;
        break;
      case 5:
        statName = 'Speed';
        statValue = pokemon.speed;
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Column(
        children: [
          Text(statName, style: statNameStyle),
          Text(statValue.toString(), style: statValueStyle),
        ],
      ),
    );
  }
}