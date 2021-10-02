// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String?,
      profileImage: fields[1] as String?,
      bio: fields[2] as String?,
      birthDay: fields[3] as String?,
      completName: fields[4] as String?,
      profileName: fields[5] as String?,
      uf: fields[7] as String?,
      city: fields[8] as String?,
      lat: fields[9] as String?,
      lng: fields[10] as String?,
      createdAt: fields[11] as DateTime?,
      email: fields[12] as String?,
      state: fields[13] as int?,
      updatedAt: fields[14] as DateTime?,
      sex: fields[15] as Sex?,
      phoneNumber: fields[6] as String?,
      emailConfirm: fields[17] as bool?,
      postsList: (fields[18] as List?)?.cast<String>(),
      entryQuizID: fields[19] as String?,
      profileComplet: fields[20] as bool,
    )..contacts = fields[16] as UserContactsModel?;
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileImage)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.birthDay)
      ..writeByte(4)
      ..write(obj.completName)
      ..writeByte(5)
      ..write(obj.profileName)
      ..writeByte(6)
      ..write(obj.phoneNumber)
      ..writeByte(7)
      ..write(obj.uf)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.lat)
      ..writeByte(10)
      ..write(obj.lng)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.email)
      ..writeByte(13)
      ..write(obj.state)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.sex)
      ..writeByte(16)
      ..write(obj.contacts)
      ..writeByte(17)
      ..write(obj.emailConfirm)
      ..writeByte(18)
      ..write(obj.postsList)
      ..writeByte(19)
      ..write(obj.entryQuizID)
      ..writeByte(20)
      ..write(obj.profileComplet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SexAdapter extends TypeAdapter<Sex> {
  @override
  final int typeId = 1;

  @override
  Sex read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Sex.NONE;
      case 1:
        return Sex.MALE;
      case 2:
        return Sex.FEMALE;
      default:
        return Sex.NONE;
    }
  }

  @override
  void write(BinaryWriter writer, Sex obj) {
    switch (obj) {
      case Sex.NONE:
        writer.writeByte(0);
        break;
      case Sex.MALE:
        writer.writeByte(1);
        break;
      case Sex.FEMALE:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SexAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
