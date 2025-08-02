import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/modules/genre/controllers/genre_controller.dart';
import 'package:movie_rent/data/models/genre_model.dart';

class GenreFilterWidget extends StatelessWidget {
  final List<int> selectedGenreIds;
  final void Function(List<int>) onSelectionChanged;

  const GenreFilterWidget({
    super.key,
    required this.selectedGenreIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final genreController = Get.find<GenreController>();

    return Obx(() {
      final state = genreController.genresState.value;

      if (state is BaseStateLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is BaseStateError) {
        return Center(child: Text('Failed to load genres'));
      }

      if (state is! BaseStateSuccess<List<GenreModel>>) {
        return const SizedBox.shrink();
      }

      final genres = state.data;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Genres', style: Theme.of(context).textTheme.labelLarge),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genres.map((genre) {
              final isSelected = selectedGenreIds.contains(genre.id);
              return FilterChip(
                label: Text(genre.name),
                selected: isSelected,
                onSelected: (selected) {
                  final updated = List<int>.from(selectedGenreIds);
                  if (selected) {
                    updated.add(genre.id);
                  } else {
                    updated.remove(genre.id);
                  }
                  onSelectionChanged(updated);
                },
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
