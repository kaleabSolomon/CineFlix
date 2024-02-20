



import 'package:flutter/material.dart';

import '../blocs/movies_bloc.dart';
import '../blocs/movies_detail_bloc_provider.dart';
import '../models/item_model.dart';
import 'movie_detail.dart';

import 'movie_list_tile.dart';

class ItemNavigation extends StatefulWidget {
  const ItemNavigation({super.key});

  @override
  State<ItemNavigation> createState() => _ItemNavigationState();
}

class _ItemNavigationState extends State<ItemNavigation> {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
  return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text('CineFlix',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                )),
          ),
        ),
       body: Listener(onPointerDown: (event){
      bloc.handleHidePopup();
    
       },
       child:  Material(
      child: StreamBuilder(
          stream: bloc.allMovies,
          builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Text('No data avaliable'),
              );
            }
      
            return const Center(child: CircularProgressIndicator());
          },
        ),
    ),
  )));
        }
    } 

   buildList(AsyncSnapshot<ItemModel?> snapshot) {
    return Column(
      children: [
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildMovieListTile('Movies',
                  ["Popular ", 'Top Rated ', 'Now Playing', 'Upcoming '], 1),
              // Padding(padding: EdgeInsets.all(4.0)),
              buildMovieListTile("TV Shows",
                  ['Popular', 'Top Rated', 'Airing Today', 'On TV'], 2),
              // Padding(padding: EdgeInsets.all(4.0)),
              buildMovieListTile('People', ['Popular People'], 3),
              // Padding(padding: EdgeInsets.all(4.0)),
              buildMovieListTile('More', ['Genre'], 4)
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: GridView.builder(
            itemCount: snapshot.data?.results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return InkResponse(
                // // we can use GestureDetector instead of InkResponse
                onTap: () {
                  openDetailPage(context,snapshot.data, index);
                },
                child: Image.network(
                  'https://image.tmdb.org/t/p/w185${snapshot.data?.results[index].poster_path}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, StackTrace) {
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  openDetailPage(BuildContext context, ItemModel? data, int index) {
    Navigator.push(context , MaterialPageRoute(builder: (context) {
      return MovieDetailBlocProvider(
        // Returning of instances of MovieDetailBlocProvider(InheritedWidget)
        // wrapping the MOvieDetail screen to it.
        // So MovieDetailBloc class will be accessible inside the detail
        // screen and to all the widgets since
        // It is in the Initializer list of the MovieDetailBlocProvider instances
        key: GlobalKey(),
        child: MovieDetail(
          title: data!.results[index].title,
          posterUrl: data!.results[index].poster_path,
          description: data!.results[index].overview,
          releaseDate: data!.results[index].release_date,
          voteAverage: data!.results[index].vote_average.toString(),
          movieId: data!.results[index].id,
        ),
      );
    }));
  }

  Widget buildMovieListTile(
      String title, List<String> popupContent, int index) {
    MovieListTile movieListTile = MovieListTile(
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
        child: Container(
          height: 25,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      txt1: popupContent.length > 0 ? popupContent[0] : '',
      txt2: popupContent.length > 1 ? popupContent[1] : '',
      txt3: popupContent.length > 2 ? popupContent[2] : '',
      txt4: popupContent.length > 3 ? popupContent[3] : '',
      index: index,
    );
    // popupContentMap[movieListTile] = popupContent;
    return movieListTile;
  }