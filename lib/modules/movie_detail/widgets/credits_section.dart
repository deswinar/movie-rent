import 'package:flutter/material.dart';
import 'package:movie_rent/data/models/cast_model.dart';
import 'package:movie_rent/data/models/crew_model.dart';

class CreditsSection extends StatelessWidget {
  final List<CastModel> cast;
  final List<CrewModel> crew;

  const CreditsSection({
    super.key,
    required this.cast,
    required this.crew,
  });

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty && crew.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Billed Cast',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length.clamp(0, 10),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final actor = cast[index];
              return SizedBox(
                width: 100,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      child: Icon(Icons.person, size: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      actor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      actor.character,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
