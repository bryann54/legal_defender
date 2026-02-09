import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/home/presentation/widgets/custom_app_bar.dart';

@RoutePage()
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CustomAppBar(
          title: AppLocalizations.getString(context, 'common.chats'),
          showNotification: true,
        ),
      ],
    );
  }
}
