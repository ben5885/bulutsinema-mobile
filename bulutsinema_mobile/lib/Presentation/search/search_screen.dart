import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Application/search/search_bloc.dart';
import '../../Application/search/search_event.dart';
import '../../Application/search/search_state.dart';
import '../../Core/colors.dart';
import '../../Domain/movie_model.dart';
import '../player/quality_sheet.dart';
import 'widgets/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<SearchBloc>().add(SearchSubmitted(_controller.text));
    FocusScope.of(context).unfocus();
  }

  void _openPlayer(Movie movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => QualitySheet(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _submit(),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Film, Dizi Ara...',
            hintStyle: const TextStyle(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: AppColors.red),
              onPressed: _submit,
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is SearchError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted),
                ),
              ),
            );
          }
          if (state is SearchEmpty) {
            return const Center(
              child: Text('Sonuç bulunamadı', style: TextStyle(color: AppColors.muted)),
            );
          }
          if (state is SearchLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return SearchResultTile(movie: movie, onTap: () => _openPlayer(movie));
              },
            );
          }
          return const Center(
            child: Text('Aramak istediğin filmi yaz', style: TextStyle(color: AppColors.muted)),
          );
        },
      ),
    );
  }
}
