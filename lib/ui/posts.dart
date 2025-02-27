import 'package:flutter/material.dart';

import 'components.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  PostsPageState createState() => PostsPageState();
}

class PostsPageState extends State<PostsPage> {
  String _selectedSort = 'Newest'; // Default sort
  final ScrollController _scrollController = ScrollController();
  List<String> _posts = List.generate(10, (index) => "Post ${index + 1}");
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

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Add 10 more posts
    setState(() {
      _posts.addAll(List.generate(10, (index) => "Post ${_currentPage * 10 + index + 1}"));
      _currentPage++;
      _isLoading = false;
    });
  }

  Future<void> _refreshPosts() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _posts = List.generate(10, (index) => "Refreshed Post ${index + 1}");
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        "Posts",
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              //
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: safeWrapContainer(
        context,
        _scrollController,
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Sort By:"),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple[800]!),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple[800]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple[800]!, width: 2.0),
                        ),
                      ),
                      value: _selectedSort,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSort = newValue;
                          });
                        }
                      },
                      items:
                          <String>['Newest', 'Lastest'].map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("$value Post"),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: _posts.length,
              itemBuilder:
                  (context, index) => PostItem(
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
              separatorBuilder: (context, index) => SizedBox(height: 16),
            ),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
