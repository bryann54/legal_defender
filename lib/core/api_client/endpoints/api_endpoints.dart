// lib/core/api_client/endpoints/api_endpoints.dart

class ApiEndpoints {
  // Auth Endpoints
  static const String authLogin = '/v1/token/';
  static const String authRegister = '/v1/users/';
  static const String authRefresh = '/v1/token/refresh/';
  static const String authOtp = '/v1/otp/send/';
  static const String authOtpVerify = '/v1/otp/verify/';
  static const String authResetPassword = '/v1/password/reset/';

  // User Endpoints
  static const String userProfile = '/v1/users/me/';
  static const String userUpdate = '/v1/users/me/';
  static const String userDelete = '/v1/users/me/';

  // Emergency Contacts
  static const String emergencyContacts = '/v1/emergency-contacts/';
  static String emergencyContactDetail(String id) =>
      '/v1/emergency-contacts/$id/';

  // Attorneys
  static const String attorneys = '/v1/attorneys/';
  static String attorneyDetail(String id) => '/v1/attorneys/$id/';
  static const String myAttorney = '/v1/attorneys/my-attorney/';
  static String selectAttorney(String id) => '/v1/attorneys/$id/select/';

  // Documents
  static const String documents = '/v1/documents/';
  static String documentDetail(String id) => '/v1/documents/$id/';
  static const String documentUpload = '/v1/documents/upload/';

  // Legal Documents
  static const String legalDocuments = '/v1/legal-documents/';
  static String legalDocumentDetail(String id) => '/v1/legal-documents/$id/';
  static String legalDocumentFill(String id) => '/v1/legal-documents/$id/fill/';

  // Alerts
  static const String alerts = '/v1/alerts/';
  static String alertDetail(String id) => '/v1/alerts/$id/';
  static String alertRespond(String id) => '/v1/alerts/$id/respond/';

  // Incidents
  static const String incidents = '/v1/incidents/';
  static String incidentDetail(String id) => '/v1/incidents/$id/';
  static const String incidentUpload = '/v1/incidents/upload/';

  // Chat
  static const String chatConversations = '/v1/chat/conversations/';
  static String chatConversationDetail(String id) =>
      '/v1/chat/conversations/$id/';
  static String chatMessages(String conversationId) =>
      '/v1/chat/conversations/$conversationId/messages/';
  static String chatSendMessage(String conversationId) =>
      '/v1/chat/conversations/$conversationId/messages/';

  // Subscription
  static const String subscriptionPlans = '/v1/subscriptions/plans/';
  static const String mySubscription = '/v1/subscriptions/my-subscription/';
  static const String subscriptionCreate = '/v1/subscriptions/';
  static const String subscriptionCancel = '/v1/subscriptions/cancel/';

  // Referrals
  static const String referrals = '/v1/referrals/';
  static const String myReferrals = '/v1/referrals/my-referrals/';
  static const String applyReferral = '/v1/referrals/apply/';
}
