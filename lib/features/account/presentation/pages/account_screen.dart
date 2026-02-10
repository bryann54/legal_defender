import 'package:auto_route/auto_route.dart';
import 'package:legal_defender/common/notifiers/locale_provider.dart';
import 'package:legal_defender/common/res/l10n.dart';
import 'package:legal_defender/features/account/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legal_defender/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountBloc accountBloc = context.read<AccountBloc>();
    final provider = Provider.of<LocaleProvider>(context);
    final currentLocale = provider.locale;

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is ChangeLanguageSuccess) {
          provider.setLocale(Locale(state.langCode));
        }
      },
      child: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: AppLocalizations.getString(
              context,
              'profile.title',
            ),
            showNotification: true,
            expandedHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                if (state is AccountLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.getString(
                            context, 'settings.language'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      state is ChangeLanguageError
                          ? Column(
                              children: [
                                Text(state.error),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () {
                                    accountBloc.add(
                                      ChangeLanguageEvent(langCode: state.lang),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.getString(
                                      context,
                                      'documents.retry',
                                    ),
                                  ),
                                )
                              ],
                            )
                          : DropdownButton<Locale>(
                              value: currentLocale,
                              items: [
                                DropdownMenuItem(
                                  value: const Locale('en'),
                                  child: Text(
                                    AppLocalizations.getString(
                                      context,
                                      'language.english',
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: const Locale('es'),
                                  child: Text(
                                    AppLocalizations.getString(
                                      context,
                                      'language.spanish',
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (locale) {
                                if (locale != null) {
                                  accountBloc.add(
                                    ChangeLanguageEvent(
                                      langCode: locale.languageCode,
                                    ),
                                  );
                                }
                              },
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
