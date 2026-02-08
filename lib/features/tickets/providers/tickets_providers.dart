import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'tickets_providers.g.dart';

/// Create ticket action
@riverpod
class CreateTicketAction extends _$CreateTicketAction {
  @override
  FutureOr<void> build() {}

  Future<Ticket?> create(
      String workstreamId, CreateTicketRequest request) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(ticketServiceProvider);
      final ticket = await service.create(workstreamId, request);
      ref.invalidate(workstreamTicketsProvider(workstreamId));
      state = const AsyncValue.data(null);
      return ticket;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// Ticket workflow actions
@riverpod
class TicketWorkflowAction extends _$TicketWorkflowAction {
  @override
  FutureOr<void> build() {}

  Future<Ticket?> triage(String id, TriageTicketRequest request) async {
    return _doAction(() => ref.read(ticketServiceProvider).triage(id, request), id);
  }

  Future<Ticket?> assign(String id, String assignedToId) async {
    return _doAction(() => ref.read(ticketServiceProvider).assign(id, assignedToId), id);
  }

  Future<Ticket?> startWork(String id) async {
    return _doAction(() => ref.read(ticketServiceProvider).startWork(id), id);
  }

  Future<Ticket?> submitForReview(String id) async {
    return _doAction(() => ref.read(ticketServiceProvider).submitForReview(id), id);
  }

  Future<Ticket?> resolve(String id, ResolveTicketRequest request) async {
    return _doAction(() => ref.read(ticketServiceProvider).resolve(id, request), id);
  }

  Future<Ticket?> close(String id) async {
    return _doAction(() => ref.read(ticketServiceProvider).close(id), id);
  }

  Future<Ticket?> wontFix(String id) async {
    return _doAction(() => ref.read(ticketServiceProvider).wontFix(id), id);
  }

  Future<Ticket?> _doAction(
      Future<Ticket> Function() action, String id) async {
    state = const AsyncValue.loading();
    try {
      final result = await action();
      ref.invalidate(ticketProvider(id));
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
