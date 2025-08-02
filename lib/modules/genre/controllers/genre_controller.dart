import 'package:get/get.dart';
import 'package:movie_rent/core/services/api_exceptions.dart';
import 'package:movie_rent/core/states/base_state.dart';
import 'package:movie_rent/data/models/genre_model.dart';
import 'package:movie_rent/data/services/movie_api_service.dart';

class GenreController extends GetxController {
  final MovieApiService _movieApiService;

  GenreController(this._movieApiService);

  @override
  void onInit() {
    super.onInit();
    fetchGenres();
  }

  final genresState = Rx<BaseState<List<GenreModel>>>(BaseStateInitial());

  List<GenreModel> get genres =>
      genresState.value is BaseStateSuccess<List<GenreModel>>
          ? (genresState.value as BaseStateSuccess<List<GenreModel>>).data
          : [];

  Future<void> fetchGenres() async {
    genresState.value = BaseStateLoading();
    try {
      final result = await _movieApiService.getGenres();
      genresState.value = BaseStateSuccess(result);
    } on ApiException catch (e) {
      genresState.value = BaseStateError(e.message);
    }
  }

  Map<int, String> get genreMap =>
    {for (var g in genres) g.id: g.name};
}
