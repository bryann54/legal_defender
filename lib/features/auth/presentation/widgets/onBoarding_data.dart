
import 'package:legal_defender/features/auth/data/models/onboarding_page_model.dart';

class OnboardingData {
  static List<OnboardingPageModel> get pages => [
        const OnboardingPageModel(
          title: 'onboarding.pages.guidance.title',
          subtitle: 'onboarding.pages.guidance.subtitle',
          iconData: '⚖️',
        ),
        const OnboardingPageModel(
          title: 'onboarding.pages.secure.title',
          subtitle: 'onboarding.pages.secure.subtitle',
          iconData: '🔒',
        ),
        const OnboardingPageModel(
          title: 'onboarding.pages.available.title',
          subtitle: 'onboarding.pages.available.subtitle',
          iconData: '🚀',
        ),
      ];
}
