import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:movie_rent/core/helpers/image_helper.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/movie_model.dart';
import 'package:movie_rent/data/models/movie_rent.dart';
import 'package:movie_rent/modules/auth/controllers/auth_controller.dart';
import 'package:movie_rent/modules/rent/controllers/rent_controller.dart';
import 'package:movie_rent/routes/app_routes.dart';

class RentMovieScreen extends StatefulWidget {
  const RentMovieScreen({super.key});

  @override
  State<RentMovieScreen> createState() => _RentMovieScreenState();
}

class _RentMovieScreenState extends State<RentMovieScreen> {
  int _rentalDays = 1;
  final int _pricePerDay = 5000;
  final RentController _rentController = Get.find();
  final userId = Get.find<AuthController>().appUser.value!.uid;

  @override
  Widget build(BuildContext context) {
    final MovieModel movie = Get.arguments as MovieModel;
    final totalPrice = _rentalDays * _pricePerDay;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final imageUrl = ImageHelper.getUrl(movie.backdropPath, size: 'w780');

    return Scaffold(
      appBar: AppBar(title: const Text('Sewa Film')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Movie Preview
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              movie.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Rental Duration Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Lama Sewa (hari)", style: TextStyle(fontSize: 16)),
                DropdownButton<int>(
                  value: _rentalDays,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _rentalDays = value);
                    }
                  },
                  items: List.generate(7, (index) {
                    final day = index + 1;
                    return DropdownMenuItem(
                      value: day,
                      child: Text('$day hari'),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Harga", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(formatter.format(totalPrice), style: const TextStyle(fontSize: 16)),
              ],
            ),

            const Spacer(),

            // Rent Button with loading/error state handling
            Obx(() {
              final state = _rentController.createRentState.value;

              if (state is BaseStateLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final rent = MovieRent(
                      movieId: movie.id,
                      title: movie.title,
                      posterUrl: movie.posterPath ?? '',
                      rentDate: Timestamp.fromDate(now),
                      expireAt: Timestamp.fromDate(now.add(Duration(days: _rentalDays))),
                      duration: _rentalDays,
                      pricePerDay: _pricePerDay,
                      totalPrice: totalPrice,
                    );

                    await _rentController.createRent(userId, rent);

                    final updatedState = _rentController.createRentState.value;
                    if (updatedState is BaseStateSuccess) {
                      Get.offAllNamed(AppRoutes.main);
                      Get.snackbar("Berhasil", "Film berhasil disewa.");
                    } else if (updatedState is BaseStateError) {
                      Get.snackbar("Error", updatedState.message);
                    }
                  },
                  icon: const Icon(Icons.shopping_cart_checkout),
                  label: const Text("Sewa Sekarang"),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
