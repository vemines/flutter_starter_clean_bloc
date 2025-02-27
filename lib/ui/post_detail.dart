import 'package:flutter/material.dart';
import 'components.dart';

// Add a Comment class
class Comment {
  String username;
  String text;
  Comment({required this.username, required this.text});
}

class PostDetailPage extends StatefulWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = []; // Store comments as a list of Comment objects

  @override
  void initState() {
    super.initState();
    // Initialize with some dummy comments.  Replace with actual data loading.
    _comments = List.generate(
      8,
      (index) =>
          Comment(username: "Username ${index + 1}", text: loremGen(words: 40, paragraphs: 1)),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(Comment(username: "Current User", text: _commentController.text));
        _commentController.clear();
      });
    }
  }

  void _showEditDialog(int index) {
    String editedComment = _comments[index].text; // Store the original comment

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Comment"),
          content: SizedBox(
            width: 600,
            child: TextFormField(
              initialValue: editedComment,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Update your comment"),
              onChanged: (value) {
                editedComment = value; // Update the editedComment variable as the user types
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _comments[index].text = editedComment;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Comment"),
          content: SizedBox(
            width: 600,
            child: const Text("Are you sure you want to delete this comment?"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _comments.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        "Post Detail",
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              //
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: safeWrapContainer(
        context,
        _scrollController,
        Column(
          children: [
            PostItem(
              id: widget.postId,
              title: loremGen(),
              body: loremGen(paragraphs: 3, words: 200),
              callback: null,
              border: const Border(),
              isDetail: true,
            ),
            const Divider(),

            // Comment Input Area
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Comments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Add a comment...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton.filled(icon: const Icon(Icons.send), onPressed: _addComment),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),
            // Comment List
            ListView.separated(
              shrinkWrap: true, // Important for nested scrolling
              itemCount: _comments.length,
              separatorBuilder:
                  (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(),
                  ),
              itemBuilder: (context, index) {
                return ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: const CircleAvatar(radius: 24, child: Icon(Icons.person, size: 30)),
                  title: Row(
                    children: [
                      Text(
                        _comments[index].username, // Use the Comment object
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(index);
                        },
                      ),
                    ],
                  ),
                  subtitle: Text(_comments[index].text), // Use the Comment object's text
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
