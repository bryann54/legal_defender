import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/home/presentation/widgets/custom_app_bar.dart';

@RoutePage()
class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CustomAppBar(
          title: AppLocalizations.getString(context, 'documents.documents'),
          showNotification: true,
        ),
      ],
    );
  }
}
