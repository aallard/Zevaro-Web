abstract class Routes {
  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  // Main
  static const dashboard = '/';
  static const projects = '/projects';
  static const projectDetail = '/projects/:id';
  static const decisions = '/decisions';
  static const decisionDetail = '/decisions/:id';
  static const outcomes = '/outcomes';
  static const outcomeDetail = '/outcomes/:id';
  static const hypotheses = '/hypotheses';
  static const hypothesisDetail = '/hypotheses/:id';
  static const experiments = '/experiments';
  static const experimentDetail = '/experiments/:id';
  static const teams = '/teams';
  static const teamDetail = '/teams/:id';
  static const stakeholders = '/stakeholders';
  static const stakeholderDetail = '/stakeholders/:id';
  static const settings = '/settings';
  static const organizationSettings = '/settings/organization';
  static const profile = '/profile';

  // Helpers
  static String projectById(String id) => '/projects/$id';
  static String decisionById(String id) => '/decisions/$id';
  static String outcomeById(String id) => '/outcomes/$id';
  static String hypothesisById(String id) => '/hypotheses/$id';
  static String experimentById(String id) => '/experiments/$id';
  static String teamById(String id) => '/teams/$id';
  static String stakeholderById(String id) => '/stakeholders/$id';
}
