import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/routes.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_bloc.dart';
import 'package:go_router/go_router.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial data load
    context.read<UserBloc>().add(GetAllUsersEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<UserBloc>().add(LoadMoreUsersEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading && state is! UsersLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.failure.message}'));
          } else {
            final users = (state is UsersLoaded) ? state.users : <UserEntity>[];
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(GetAllUsersEvent());
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    users.length +
                    (state is UsersLoaded && state.hasMore ? 1 : 0), // Add loading indicator,
                itemBuilder: (context, index) {
                  if (index < users.length) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar), // Display user avatar
                      ),
                      title: Text(user.userName),
                      subtitle: Text(user.email),
                      trailing: ElevatedButton(
                        onPressed: () {
                          context.push('${Paths.userProfile}/${user.id}');
                        },
                        child: Text('View Profile'),
                      ),
                      onTap: () {
                        context.push('${Paths.userProfile}/${user.id}');
                      },
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
