import 'package:flutter/material.dart';
import '../core/extensions/build_content_extensions.dart';

import 'components.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  final List<String> _user = List.generate(10, (index) => "Post ${index + 1}");

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
      _user.addAll(List.generate(10, (index) => "Post ${_currentPage * 10 + index + 1}"));
      _currentPage++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Users"),
      body: safeWrapContainer(
        border: context.width > 1024 ? null : Border.all(color: Colors.black26),
        context,
        _scrollController,
        Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == 0) return _buildUserProfile(context);

                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text("User index: $index"),
                  trailing: ElevatedButton(onPressed: () {}, child: Text('Action')),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/user_detail',
                      arguments: <String, int>{'userId': index},
                    ); // Pass isCurrentUser
                  },
                );
              },
              itemCount: _user.length + 1,
            ),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        Navigator.pushNamed(
          context,
          '/user_detail',
          arguments: <String, dynamic>{'userId': 1234, 'isProfile': true},
        );
      },
      child: SizedBox(
        height: 350, // Adjust overall height as needed
        child: Stack(
          children: [
            // Cover image
            Container(
              height: 250, // 50% of the SizedBox height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network("https://picsum.photos/1200/450?random=1").image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            _buildUserAvatar(context),

            _buildUserDeatil(context),
          ],
        ),
      ),
    );
  }

  Positioned _buildUserDeatil(BuildContext context) {
    return Positioned(
      top: 260,
      left: 30 + 180 + 40,
      width: 1200 - 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User Fullname",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Center align text
          ),
          SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/user_detail',
                arguments: <String, dynamic>{'userId': 1234, 'isProfile': true},
              );
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            ),
            child: Text('View Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.surface;
    return Positioned(
      top: 135,
      left: 16, // Start from the left edge
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: bgColor, width: 10),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 90,
          backgroundImage: NetworkImage(
            "https://picsum.photos/300/300?random=2",
          ), // Example avatar image
        ),
      ),
    );
  }
}
