// feed_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/feed_list_cubit.dart';
import 'feed_detail_page.dart';

class FeedListView extends StatelessWidget {
  const FeedListView({super.key});

  void _showDeleteConfirmation(BuildContext context, int feedId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Delete Confirmation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Are you sure you want to delete this feed?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FeedListCubit>().removeData(feedId);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed App'),
        elevation: 2,
      ),
      body: BlocBuilder<FeedListCubit, FeedListState>(
        builder: (context, state) {
          if (state is FeedListSuccess) {
            return ListView.builder(
              itemCount: state.feeds.length,
              itemBuilder: (context, index) {
                final feed = state.feeds[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        feed.title.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      feed.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      feed.body.length > 50
                          ? '${feed.body.substring(0, 50)}...'
                          : feed.body,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedDetailPage(feed: feed),
                        ),
                      );
                    },
                    onLongPress: () => _showDeleteConfirmation(context, feed.id),
                  ),
                );
              },
            );
          } else if (state is FeedListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Try Again"),
                    onPressed: () => context.read<FeedListCubit>().fetchFeed(),
                  ),
                ],
              ),
            );
          } else if (state is FeedListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Load Feeds"),
              onPressed: () => context.read<FeedListCubit>().fetchFeed(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => context.read<FeedListCubit>().fetchFeed(),
      ),
    );
  }
}