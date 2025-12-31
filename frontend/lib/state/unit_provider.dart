
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/unit_model.dart';
import 'package:frontend/data/repositories/unit_repository.dart';
import 'package:frontend/data/services/api/unit_api.dart';


// DESPENDENCY

final unitApiProvider = Provider<UnitApi>((ref) => UnitApi());

final unitRepositoryProvider = Provider<UnitRepository>((ref) => UnitRepository(ref.read(unitApiProvider)));

// PROVIDER WITHOUT NOTIFIER, WHY? BECAUSE JUST READ DATA :)

final unitProvider = FutureProvider<List<UnitModel>>((ref) async {
  final repo = ref.watch(unitRepositoryProvider);
  return repo.getUnit();
});