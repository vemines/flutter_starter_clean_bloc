// import 'package:flutter/material.dart';

// import 'components.dart';
// import 'post_detail.dart';
// import 'posts.dart';
// import 'search.dart';
// import 'settings.dart';
// import 'user_detail.dart';
// import 'users.dart';

// // ignore: depend_on_referenced_packages
// import 'package:device_preview/device_preview.dart';

// void main() => runApp(
//   DevicePreview(
//     builder: (context) => MyApp(), // Wrap your app
//   ),
// );

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Social App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       // home: HomePage(), // Use a RootPage to manage bottom navigation
//       onGenerateRoute: (settings) {
//         if (settings.name == '/post_detail') {
//           final args = settings.arguments;

//           // Correctly handle the Map argument
//           if (args is Map<String, int>) {
//             final postId = args['postId'];
//             if (postId != null) {
//               return MaterialPageRoute(builder: (context) => PostDetailPage(postId: postId));
//             }
//           }
//           // If arguments are invalid, show PageNotFound
//           return MaterialPageRoute(builder: (context) => const PageNotFound());
//         } else if (settings.name == '/user_detail') {
//           final args = settings.arguments;

//           // Correctly handle the Map argument
//           if (args is Map<String, dynamic>) {
//             final userId = args['userId'];
//             final isProfile = args['isProfile'];
//             if (userId != null) {
//               return MaterialPageRoute(
//                 builder: (context) => UserDetailPage(userId: userId, isProfile: isProfile ?? false),
//               );
//             }
//           }
//           return MaterialPageRoute(builder: (context) => const PageNotFound());
//         }

//         // Define other routes similarly
//         switch (settings.name) {
//           case '/':
//             return MaterialPageRoute(builder: (context) => const HomePage());
//           case '/home': //Redundant with '/' but included for clarity
//             return MaterialPageRoute(builder: (context) => const HomePage());
//           default:
//             return MaterialPageRoute(builder: (context) => const PageNotFound());
//         }
//       },
//       initialRoute: '/',
//     );
//   }
// }

// // --- Root Page (Handles Bottom Navigation) ---
// class HomePage extends StatefulWidget {
//   const HomePage({super.key, this.tabIndex = 0});
//   final int? tabIndex;

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   late int _selectedIndex;
//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.tabIndex!;
//   }

//   final List<Widget> _pages = [PostsPage(), SearchPage(), UsersPage(), SettingsPage()];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         // Use IndexedStack to preserve state
//         index: _selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Posts'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//         ],
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Data Model ---
class Item {
  final String name;
  final Key key;

  Item({required this.name}) : key = UniqueKey();
}

// --- Events ---
abstract class ItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchItems extends ItemEvent {}

// --- States ---
abstract class ItemState extends Equatable {
  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  final bool hasReachedMax;

  ItemLoaded({required this.items, this.hasReachedMax = false});

  ItemLoaded copyWith({List<Item>? items, bool? hasReachedMax}) {
    return ItemLoaded(
      items: items != null ? [...this.items, ...items] : this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [items, hasReachedMax];
}

class ItemError extends ItemState {
  final String message;
  ItemError({required this.message});

  @override
  List<Object> get props => [message];
}

// --- Bloc ---
class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final int _itemsPerPage = 20;
  int _currentPage = 1;

  ItemBloc() : super(ItemInitial()) {
    on<FetchItems>(_onFetchItems);
  }

  Future<void> _onFetchItems(FetchItems event, Emitter<ItemState> emit) async {
    if (state is ItemLoaded && (state as ItemLoaded).hasReachedMax) return;

    if (state is! ItemLoaded) {
      emit(ItemLoading());
    }

    await Future.delayed(const Duration(seconds: 1));

    final List<Item> newItems = List.generate(
      _itemsPerPage,
      (index) => Item(name: 'Item ${(_currentPage - 1) * _itemsPerPage + index + 1}'),
    );

    if (newItems.isEmpty) {
      if (state is ItemLoaded) {
        emit((state as ItemLoaded).copyWith(hasReachedMax: true));
      } else {
        emit(ItemLoaded(items: [], hasReachedMax: true));
      }
    } else {
      _currentPage++;
      if (state is ItemLoaded) {
        emit((state as ItemLoaded).copyWith(items: newItems));
      } else {
        emit(ItemLoaded(items: newItems));
      }
    }
  }
}

// --- Widget ---
class InfiniteScrollList extends StatefulWidget {
  const InfiniteScrollList({super.key});

  @override
  InfiniteScrollListState createState() => InfiniteScrollListState();
}

class InfiniteScrollListState extends State<InfiniteScrollList> {
  final _scrollController = ScrollController();
  late ItemBloc _itemBloc;

  @override
  void initState() {
    super.initState();
    _itemBloc = ItemBloc()..add(FetchItems());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    //_itemBloc.close(); //Bloc should close.
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _itemBloc.add(FetchItems());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9); // Use 90% threshold
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Infinite Scroll MVE')),
        body: BlocProvider<ItemBloc>.value(
          value: _itemBloc,
          child: BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              if (state is ItemInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ItemLoading && state is! ItemLoaded) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ItemLoaded) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax ? state.items.length : state.items.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return !state.hasReachedMax
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    } else {
                      return ListTile(
                        key: state.items[index].key,
                        title: Text(state.items[index].name),
                      );
                    }
                  },
                );
              } else if (state is ItemError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text("Unknown State"));
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const InfiniteScrollList());
}
