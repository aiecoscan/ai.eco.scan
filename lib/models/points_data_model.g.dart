// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointsDataModelAdapter extends TypeAdapter<PointsDataModel> {
  @override
  final int typeId = 2;

  @override
  PointsDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PointsDataModel(
      userId: fields[0] as String,
      totalPoints: fields[1] as int,
      recycledKg: fields[2] as int,
      recycledTimes: fields[3] as int,
      rewardTypes: (fields[4] as List?)?.cast<String>(),
      pointAmounts: (fields[5] as List?)?.cast<int>(),
      transactionDates: (fields[6] as List?)?.cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, PointsDataModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.totalPoints)
      ..writeByte(2)
      ..write(obj.recycledKg)
      ..writeByte(3)
      ..write(obj.recycledTimes)
      ..writeByte(4)
      ..write(obj.rewardTypes)
      ..writeByte(5)
      ..write(obj.pointAmounts)
      ..writeByte(6)
      ..write(obj.transactionDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointsDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
