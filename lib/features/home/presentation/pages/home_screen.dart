import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:legal_defender/common/widgets/custom_app_bar.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomAppBar(
            isHome: true,
            showNotification: true,
          ),

          // Your content below
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Item #$index'),
                subtitle: const Text('Subtitle here'),
                leading: const Icon(Icons.description),
                onTap: () {},
              ),
              childCount: 20,
            )),
          ),
        ],
      ),
    );
  }
}
