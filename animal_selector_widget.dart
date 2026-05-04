import 'package:flutter/material.dart';
import '../models/animal_config.dart';

class AnimalSelectorWidget extends StatelessWidget {
  final AnimalConfig selected;
  final ValueChanged<AnimalConfig> onSelected;

  const AnimalSelectorWidget({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: AnimalConfig.all.length,
        itemBuilder: (context, i) {
          final animal = AnimalConfig.all[i];
          final isSelected = animal.type == selected.type;
          return GestureDetector(
            onTap: () => onSelected(animal),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              width: isSelected ? 64 : 54,
              height: isSelected ? 64 : 54,
              decoration: BoxDecoration(
                color: isSelected ? animal.primaryColor.withOpacity(0.22) : const Color(0xFF16161F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? animal.primaryColor : Colors.white.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: animal.primaryColor.withOpacity(0.35), blurRadius: 12, spreadRadius: 1)]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(animal.emoji, style: TextStyle(fontSize: isSelected ? 26 : 22)),
                  if (isSelected)
                    Text(
                      animal.name,
                      style: TextStyle(
                        fontSize: 8.5,
                        color: animal.primaryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
