import 'package:farmtec/features/farm/data/datasources/farm_local_datasource.dart';
import 'package:farmtec/features/farm/domain/entities/farm.dart';
import 'package:farmtec/features/farm/domain/repositories/farm_repository.dart';

class FarmRepositoryImpl implements FarmRepository {
  FarmRepositoryImpl({FarmLocalDataSource? dataSource})
      : _dataSource = dataSource ?? FarmLocalDataSource();

  final FarmLocalDataSource _dataSource;
  List<Farm> _farms = [];
  String? _selectedFarmId;

  @override
  Future<List<Farm>> getFarms() async {
    if (_farms.isEmpty) await _reload();
    return List.unmodifiable(_farms);
  }

  @override
  Future<Farm?> getSelectedFarm() async {
    if (_farms.isEmpty) await _reload();
    if (_farms.isEmpty) return null;
    return _farms.firstWhere(
      (f) => f.id == _selectedFarmId,
      orElse: () => _farms.first,
    );
  }

  @override
  Future<void> selectFarm(String farmId) async {
    _selectedFarmId = farmId;
    await _dataSource.saveFarms(_farms, farmId);
  }

  @override
  Future<void> addFarm(Farm farm) async {
    _farms = [..._farms, farm];
    _selectedFarmId = farm.id;
    await _dataSource.saveFarms(_farms, farm.id);
  }

  @override
  Future<void> removeFarm(String farmId) async {
    _farms = _farms.where((f) => f.id != farmId).toList();
    if (_selectedFarmId == farmId) {
      _selectedFarmId = _farms.isNotEmpty ? _farms.first.id : null;
    }
    await _dataSource.saveFarms(_farms, _selectedFarmId);
  }

  Future<void> _reload() async {
    _farms = await _dataSource.loadFarms();
    _selectedFarmId = await _dataSource.loadSelectedFarmId();
    if (_farms.isNotEmpty && _selectedFarmId == null) {
      _selectedFarmId = _farms.first.id;
      await _dataSource.saveFarms(_farms, _selectedFarmId);
    }
  }
}
