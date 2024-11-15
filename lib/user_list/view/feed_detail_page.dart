// feed_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/feed.dart';
import '../cubit/feed_list_cubit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedDetailPage extends StatefulWidget {
  const FeedDetailPage({super.key, required this.feed});
  final Feed feed;

  @override
  State<FeedDetailPage> createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends State<FeedDetailPage> {
  Map<String, dynamic>? additionalData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdditionalData();
  }

  Future<void> _loadAdditionalData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/${widget.feed.id}'),
      );
      
      if (response.statusCode == 200) {
        setState(() {
          additionalData = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Feed'),
          content: const Text('Are you sure you want to delete this feed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<FeedListCubit>().removeData(widget.feed.id);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to list
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        widget.feed.title.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.feed.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.feed.body,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (additionalData != null) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Additional Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('User ID: ${additionalData!['userId']}'),
                    Text('Post ID: ${additionalData!['id']}'),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    onPressed: () {
                      final prevFeed = context
                          .read<FeedListCubit>()
                          .getPreviousFeed(widget.feed.id);
                      if (prevFeed != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeedDetailPage(feed: prevFeed),
                          ),
                        );
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    onPressed: () {
                      final nextFeed = context
                          .read<FeedListCubit>()
                          .getNextFeed(widget.feed.id);
                      if (nextFeed != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeedDetailPage(feed: nextFeed),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}