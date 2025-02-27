import 'package:flutter/material.dart';
import 'components.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String _searchQuery = "";
  List<String> _searchResults = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading || _searchQuery.isEmpty) return;
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Add 10 more posts
    setState(() {
      _searchResults.addAll(List.generate(10, (index) => "Post ${_currentPage * 10 + index + 1}"));
      _currentPage++;
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMorePosts();
    }
  }

  void _performSearch() {
    setState(() {
      _searchResults = []; // Clear previous results
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_searchQuery.isEmpty) {
          _searchResults = []; // No results if query is empty
        } else {
          // Dummy results - replace with your actual search implementation
          _searchResults = List.generate(
            10,
            (index) => "Post ${_currentPage * 10 + index + 1} for '$_searchQuery'",
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Search"),
      body: safeWrapContainer(
        context,
        _scrollController,
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Posts',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8), // Add some spacing
                ElevatedButton(onPressed: _performSearch, child: Text('Search')),
              ],
            ),
            SizedBox(height: 16),
            _searchResults.isEmpty
                ? Center(child: Text("Search posts by title or content"))
                : ListView.separated(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PostItem(
                          id: index,
                          title: loremGen(),
                          body: loremGen(paragraphs: 3, words: 200),
                          callback: () {
                            Navigator.pushNamed(
                              context,
                              '/post_detail',
                              arguments: <String, int>{'postId': index},
                            );
                          },
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                ),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
