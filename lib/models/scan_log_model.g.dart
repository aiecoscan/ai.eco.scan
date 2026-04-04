// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanLogModelAdapter extends TypeAdapter<ScanLogModel> {
  @override
  final int typeId = 1;

  @override
  ScanLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanLogModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      wasteType: fields[2] as String,
      confidence: fields[3] as double,
      imagePath: fields[4] as String,
      status: fields[5] as String,
      scannedAt: fields[6] as DateTime,
      pointsEarned: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScanLogModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.wasteType)
      ..writeByte(3)
      ..write(obj.confidence)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.scannedAt)
      ..writeByte(7)
      ..write(obj.pointsEarned)
      ..writeByte(8)
      ..write(obj._weightGrams);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
