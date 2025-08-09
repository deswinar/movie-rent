import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:movie_rent/data/models/movie_rent.dart';
import 'package:movie_rent/routes/app_routes.dart';

class MovieRentTile extends StatelessWidget {
  final MovieRent rent;

  const MovieRentTile({super.key, required this.rent});

  @override
  Widget build(BuildContext context) {
    final DateTime rentDateTime = rent.rentDate.toDate();

    // Format the date
    final formattedDate = DateFormat('dd MMMM yyyy').format(rentDateTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          rent.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Status: ${rent.status}"),
            Text("Rented on: $formattedDate"),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Get.toNamed(AppRoutes.rentMovieDetail, arguments: rent);
        },
      ),
    );
  }
}
