// lib/core/api_client/endpoints/api_endpoints.dart

class ApiEndpoints {
  // Auth Endpoints
  static const String authChangePassword = '/auth/change-password/';
  static const String authLogin = '/v1/token/';
  static const String createUser = '/v1/users/';
  static const String authMerchantsDarajaCreate =
      '/auth/merchants/daraja/create/';
  static const String authMerchantsDarajaMe = '/auth/merchants/daraja/me/';
  static const String authMerchantsMe = '/auth/merchants/me/';
  static const String authMerchantsUpdate = '/auth/merchants/update/';
  static const String authOtpVerify = '/auth/otp-verify/';
  static const String authOtp = '/auth/otp/';
  static const String authRegister = '/auth/register/';

  // Payments Endpoints
  static const String paymentsConfirmationCallback =
      '/payments/confirmation-callback';
  static const String paymentsCredsTest = '/payments/creds/test/';
  static const String paymentsExpressPayments = '/payments/express-payments/';
  static const String paymentsExpressPaymentsTest =
      '/payments/express-payments/test/';
  static const String paymentsRegisterUrls = '/payments/register-urls/';
  static const String paymentsValidationCallback =
      '/payments/validation-callback';

  // Shows Endpoints
  static const String showsAll = '/shows/all/';
  static String showBySlug(String slug) => '/shows/all/$slug/';
  static String showDetails(String slug) => '/shows/all/$slug/details/';
  static const String showsCacheStatus = '/shows/cache-status/';
  static const String showsCreate = '/shows/create/';

  // Ticket Types Endpoints
  static const String showsTicketTypesCreate = '/shows/ticket-types/create/';
  static String showsTicketTypesByShow(String showId) =>
      '/shows/ticket-types/show/$showId/';
  static String showsTicketTypesByShowMerchant(String showId) =>
      '/shows/ticket-types/show/$showId/merchant/';
  static String showsTicketTypesById(String id) => '/shows/ticket-types/$id/';

  // Tickets Endpoints
  static const String showsTicketsBulkCreate = '/shows/tickets/bulk-create/';
  static const String showsTicketsBulkOpenShowCreate =
      '/shows/tickets/bulk-open-show-create/';
  static String showsTicketsCustomersCheckin(String stageId) =>
      '/shows/tickets/customers/$stageId/checkin/';
  static const String showsTicketsReserve = '/shows/tickets/reserve/';
  static const String showsTicketsSales = '/shows/tickets/sales/';
  static String showsTicketsSalesStatus(String stageId) =>
      '/shows/tickets/sales/$stageId/status/';
  static String showsTicketsShowSales(String slug) =>
      '/shows/tickets/show/$slug/sales/';
  static const String showsTicketsUserPurchases =
      '/shows/tickets/user/purchases/';
  static String showsTicketsDetails(String id) => '/shows/tickets/$id/details/';
  static String showsTicketsPurchaseCart(String id) =>
      '/shows/tickets/$id/purchase-cart/';
  static String showsTicketsPurchaseMap(String id) =>
      '/shows/tickets/$id/purchase-map/';

  // Venues Endpoints
  static String venueById(String id) => '/venues/all/$id/';
  static const String venuesCreate = '/venues/create/';
  static const String venuesMerchantVenues = '/venues/merchant/venues/';
  static const String venuesSeatRowsCreate = '/venues/seat-rows/create/';
  static String venuesSeatRowsUpdate(String id) =>
      '/venues/seat-rows/$id/update/';
  static const String venuesSeatsCreate = '/venues/seats/create/';
  static String venuesSeatsUpdate(String id) => '/venues/seats/$id/update/';

  // Legacy endpoints (keep for backward compatibility if needed)
  static String showById(String id) => '/shows/all/$id/';
  static String showsTicketsById(String id) => '/shows/tickets/$id/';
}
