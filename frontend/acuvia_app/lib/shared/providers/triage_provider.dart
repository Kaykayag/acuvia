import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/triage.dart';
import '../../../data/repositories/triage_repository.dart';

final triageResultProvider = StateProvider<TriageResult?>((_) => null);

final triageControllerProvider = Provider<TriageController>(
  TriageController.new,
);

class TriageController {
  TriageController(this._ref);
  final Ref _ref;

  Future<TriageResult> submit({
    required List<String> symptoms,
    required int age,
    required String sex,
    String freeText = '',
    List<String> conditions = const [],
  }) async {
    final req = TriageRequest(
      symptoms:   symptoms,
      freeText:   freeText,
      age:        age,
      sex:        sex,
      conditions: conditions,
    );
    final result = await _ref.read(triageRepositoryProvider).submit(req);
    _ref.read(triageResultProvider.notifier).state = result;
    return result;
  }

  void clear() => _ref.read(triageResultProvider.notifier).state = null;
}