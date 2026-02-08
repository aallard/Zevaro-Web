import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zevaro_flutter_sdk/zevaro_flutter_sdk.dart';

part 'portfolios_providers.g.dart';

/// Create portfolio action
@riverpod
class CreatePortfolioAction extends _$CreatePortfolioAction {
  @override
  FutureOr<void> build() {}

  Future<Portfolio?> create(CreatePortfolioRequest request) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(portfolioServiceProvider);
      final portfolio = await service.create(request);

      ref.invalidate(portfoliosProvider);

      state = const AsyncValue.data(null);
      return portfolio;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
