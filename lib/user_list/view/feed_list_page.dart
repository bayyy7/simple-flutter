import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/feed_list_cubit.dart';
import 'feed_list_view.dart';



class FeedListPage extends StatelessWidget {
  const FeedListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedListCubit(),
      child: const FeedListView(),
    );
  }
}