import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';

class UserProfilePage extends StatefulWidget {
  final int userId;
  final bool isProfile;
  const UserProfilePage({super.key, required this.userId, this.isProfile = false});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Controllers for editable fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  // Add other controllers as needed (e.g., for bio, profile picture)

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserByIdEvent(id: widget.userId));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile(UserEntity user) {
    final updatedUser = user.copyWith(
      fullName: _nameController.text,
      email: _emailController.text,
      // Update other fields as needed
    );
    context.read<UserBloc>().add(UpdateUserEvent(user: updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isProfile
              ? AppBar(
                title: const Text("My Profile"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/update_user');
                      //  context.go('${Paths.userProfile}/${widget.userId}', extra: true);
                    },
                  ),
                ],
              )
              : AppBar(title: const Text("User Detail")),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failure.message ?? 'Update failed.')));
          } else if (state is UserLoaded) {
            // UserLoaded after update
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.failure.message}'));
          } else if (state is UserLoaded) {
            final user = state.user;

            // Pre-fill the text fields with current user data
            _nameController.text = user.fullName;
            _emailController.text = user.email;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display user information (non-editable)
                    Center(
                      child: CircleAvatar(radius: 50, backgroundImage: NetworkImage(user.avatar)),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        user.userName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Editable fields
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),

                    // Add other editable fields (bio, profile picture, etc.)
                    ElevatedButton(
                      onPressed: () => _saveProfile(user),
                      child: const Text('Save Changes'),
                    ),

                    const SizedBox(height: 8),
                    Text('Friends: ${user.friendsId.length}'), // Example: Show number of friends
                    const SizedBox(height: 8),
                    Text('Bookmarked: ${user.bookmarksId.length}'),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
