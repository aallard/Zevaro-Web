import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

/// Returns the route path for a given entity type and ID.
String getEntityRoute(EntityType type, String id) {
  switch (type) {
    case EntityType.PORTFOLIO:
      return '/portfolios/$id';
    case EntityType.PROGRAM:
      return '/programs/$id';
    case EntityType.WORKSTREAM:
      return '/workstreams/$id';
    case EntityType.OUTCOME:
      return '/outcomes/$id';
    case EntityType.HYPOTHESIS:
      return '/hypotheses/$id';
    case EntityType.EXPERIMENT:
      return '/experiments/$id';
    case EntityType.DECISION:
      return '/decisions/$id';
    case EntityType.SPECIFICATION:
      return '/specifications/$id';
    case EntityType.REQUIREMENT:
      return '/requirements/$id';
    case EntityType.TICKET:
      return '/tickets/$id';
    case EntityType.DOCUMENT:
      return '/documents/$id';
    case EntityType.SPACE:
      return '/spaces/$id';
  }
}

/// Returns a human-readable label for an entity type.
String entityTypeLabel(EntityType type) {
  switch (type) {
    case EntityType.PORTFOLIO:
      return 'Portfolio';
    case EntityType.PROGRAM:
      return 'Program';
    case EntityType.WORKSTREAM:
      return 'Workstream';
    case EntityType.OUTCOME:
      return 'Outcome';
    case EntityType.HYPOTHESIS:
      return 'Hypothesis';
    case EntityType.EXPERIMENT:
      return 'Experiment';
    case EntityType.DECISION:
      return 'Decision';
    case EntityType.SPECIFICATION:
      return 'Specification';
    case EntityType.REQUIREMENT:
      return 'Requirement';
    case EntityType.TICKET:
      return 'Ticket';
    case EntityType.DOCUMENT:
      return 'Document';
    case EntityType.SPACE:
      return 'Space';
  }
}

/// Returns an icon-appropriate string for link types.
String linkTypeLabel(LinkType type) {
  switch (type) {
    case LinkType.REFERENCES:
      return 'References';
    case LinkType.BLOCKS:
      return 'Blocks';
    case LinkType.DEPENDS_ON:
      return 'Depends on';
    case LinkType.RELATES_TO:
      return 'Relates to';
    case LinkType.IMPLEMENTS:
      return 'Implements';
  }
}
