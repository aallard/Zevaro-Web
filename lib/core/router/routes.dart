abstract class Routes {
  // Auth
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  // Main
  static const dashboard = '/';
  static const portfolios = '/portfolios';
  static const portfolioDetail = '/portfolios/:id';
  static const portfolioNew = '/portfolios/new';
  static const programs = '/programs';
  static const programDetail = '/programs/:id';
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
  static const workstreams = '/workstreams';
  static const workstreamDetail = '/workstreams/:id';
  static const specifications = '/specifications';
  static const specificationDetail = '/specifications/:id';
  static const requirements = '/requirements';
  static const requirementDetail = '/requirements/:id';
  static const tickets = '/tickets';
  static const ticketDetail = '/tickets/:id';
  static const spaces = '/spaces';
  static const spaceDetail = '/spaces/:id';
  static const documents = '/documents';
  static const documentDetail = '/documents/:id';
  static const documentEditPath = '/documents/:id/edit';
  static const search = '/search';
  static const templates = '/templates';
  static const activity = '/activity';
  static const settings = '/settings';
  static const organizationSettings = '/settings/organization';
  static const profile = '/profile';

  // Helpers
  static String portfolioById(String id) => '/portfolios/$id';
  static String programById(String id) => '/programs/$id';
  static String decisionById(String id) => '/decisions/$id';
  static String outcomeById(String id) => '/outcomes/$id';
  static String hypothesisById(String id) => '/hypotheses/$id';
  static String experimentById(String id) => '/experiments/$id';
  static String teamById(String id) => '/teams/$id';
  static String stakeholderById(String id) => '/stakeholders/$id';
  static String workstreamById(String id) => '/workstreams/$id';
  static String specificationById(String id) => '/specifications/$id';
  static String requirementById(String id) => '/requirements/$id';
  static String ticketById(String id) => '/tickets/$id';
  static String spaceById(String id) => '/spaces/$id';
  static String documentById(String id) => '/documents/$id';
  static String documentEdit(String id) => '/documents/$id/edit';
}
