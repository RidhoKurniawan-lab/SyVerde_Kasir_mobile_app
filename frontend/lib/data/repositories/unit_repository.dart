import 'package:frontend/data/models/response/unit_model.dart';
import 'package:frontend/data/services/api/unit_api.dart';

class UnitRepository {
  final UnitApi api;

  UnitRepository(this.api);

  Future<List<UnitModel>> getUnit() async {
    try{
      final response = await api.getUnit();

      return response.map<UnitModel>((json) => UnitModel.fromJson(json)).toList();
    }catch (e) {
      rethrow;
    }
  }
}