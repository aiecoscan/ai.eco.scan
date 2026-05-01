// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BinModelAdapter extends TypeAdapter<BinModel> {
  @override
  final int typeId = 3;

  @override
  BinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BinModel(
      id: fields[0] as String,
      name: fields[1] as String,
      city: fields[2] as String,
      district: fields[3] as String,
      isActive: fields[4] as bool,
      reportCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BinModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.district)
      ..writeByte(4)
      ..write(obj.isActive)
      ..writeByte(5)
      ..write(obj.reportCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
