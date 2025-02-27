import 'package:flutter/material.dart';

import 'components.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;
  final bool isProfile;
  const UserDetailPage({super.key, required this.userId, this.isProfile = false});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _posts = List.generate(10, (index) => "Post ${index + 1}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isProfile
          ? buildAppBar(
              context,
              "My Profile",
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, '/update_user');
                  },
                ),
              ],
            )
          : buildAppBar(context, "User Detail"),
      body: safeWrapContainer(
        context,
        _scrollController,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(context),
            Center(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(child: Text("Posts", style: TextStyle(fontSize: 16))),
                          ),
                          Container(width: 2, height: 50, color: Colors.black38),
                          Expanded(
                            child: Center(
                              child: Text("Comments", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 200, height: 2, color: Colors.black38),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "100 K",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(width: 2, height: 50, color: Colors.black45),
                          Expanded(
                            child: Center(
                              child: Text(
                                "100 M",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildUserDetail(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "My Posts",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return PostItem(
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
                );
              },
              itemCount: _posts.length,
            ),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Padding _buildUserDetail() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About me', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          SizedBox(height: 10),
          Text(loremGen(words: 50)),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 10),
              Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 20),
              Text(loremGen()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 10),
              Text("Date Create:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 20),
              Text(DateTime.now().toString()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.update),
              SizedBox(width: 10),
              Text("Lastest update:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 20),
              Text(DateTime.now().toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return SizedBox(
      height: 400, // Adjust overall height as needed
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
    );
  }

  Positioned _buildUserDeatil(BuildContext context) {
    return Positioned(
      top: 330,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          "User Fullname",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center, // Center align text
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.surface;
    return Positioned(
      top: 135,
      left: 0,
      right: 0,
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
