import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_rent/core/enums/sort_option.dart';
import 'package:movie_rent/modules/movie_explore/widgets/date_range_field.dart';
import 'package:movie_rent/modules/movie_explore/widgets/dropdown_field.dart';
import 'package:movie_rent/modules/movie_explore/widgets/range_slider_field.dart';
import 'package:movie_rent/modules/movie_explore/widgets/year_filter.dart';
import 'package:movie_rent/modules/movie_explore/controllers/movie_explore_controller.dart';
import 'package:movie_rent/modules/movie_explore/widgets/genre_filter_widget.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MovieExploreController>();
    final filter = controller.filter;

    return Obx(() {
      final f = filter.value;
      return SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Keywords
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Keywords',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: f.withKeywords ?? ''),
                onSubmitted: (value) {
                  controller.discover(f.copyWith(
                    withKeywords: value.trim().isEmpty ? null : value.trim(),
                  ));
                },
              ),
              const SizedBox(height: 12),

              // Release Date Range
              DateRangeField(
                label: 'Release Date Range',
                startDate: f.releaseDateGte != null ? DateTime.tryParse(f.releaseDateGte!) : null,
                endDate: f.releaseDateLte != null ? DateTime.tryParse(f.releaseDateLte!) : null,
                onChanged: (start, end) {
                  controller.discover(f.copyWith(
                    releaseDateGte: start?.toIso8601String(),
                    releaseDateLte: end?.toIso8601String(),
                  ));
                },
              ),
              const SizedBox(height: 12),

              // Vote Average Range
              RangeSliderField(
                label: 'Vote Average',
                min: 0,
                max: 10,
                start: f.voteAverageGte ?? 0,
                end: f.voteAverageLte ?? 10,
                onChanged: (start, end) {
                  controller.discover(f.copyWith(
                    voteAverageGte: start,
                    voteAverageLte: end,
                  ));
                },
              ),
              const SizedBox(height: 12),

              // Year
              YearFilter(
                selectedYear: f.year,
                onChanged: (year) {
                  controller.discover(f.copyWith(year: year));
                },
              ),
              const SizedBox(height: 12),

              // Genres
              GenreFilterWidget(
                selectedGenreIds: f.genreIds ?? [],
                onSelectionChanged: (ids) {
                  controller.discover(f.copyWith(genreIds: ids));
                },
              ),
              const SizedBox(height: 12),

              // Sort By
              DropdownField<SortOption>(
                label: 'Sort By',
                value: SortOptionExtension.fromApiValue(f.sortBy ?? 'popularity.desc'),
                items: SortOption.values,
                labelBuilder: (item) => item.label,
                onChanged: (option) {
                  if (option != null) {
                    controller.discover(f.copyWith(sortBy: option.apiValue));
                  }
                },
              ),
              const SizedBox(height: 12),

              // Include Adult Content
              SwitchListTile(
                title: const Text('Include Adult Content'),
                value: f.includeAdult,
                onChanged: (val) {
                  controller.discover(f.copyWith(includeAdult: val));
                },
              ),

              // Reset Filters Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: controller.clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear All Filters'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
