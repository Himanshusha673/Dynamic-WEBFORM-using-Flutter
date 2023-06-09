class MyData {
  List<ColumnFileds> schema;

  MyData({required this.schema});

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      schema: List<ColumnFileds>.from(
          json['result'].map((column) => ColumnFileds.fromJson(column))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['result'] =
        List<dynamic>.from(schema.map((column) => column.toJson()));
    return data;
  }
}

class ColumnFileds {
  String columnName;
  String dataType;
  String columnDescription;
  String mode;
  int columnId;

  ColumnFileds({
    required this.columnName,
    required this.dataType,
    required this.columnDescription,
    required this.mode,
    required this.columnId,
  });
  ColumnFileds copy({
    String? columnName,
    String? datatype,
    String? columnDescription,
    int? column_id,
    String? mode,
  }) =>
      ColumnFileds(
        columnName: columnName ?? this.columnName,
        columnId: column_id ?? columnId,
        dataType: datatype ?? dataType,
        mode: mode ?? this.mode,
        columnDescription: columnDescription ?? this.columnDescription,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnFileds &&
          runtimeType == other.runtimeType &&
          columnName == other.columnName &&
          columnId == other.columnId &&
          dataType == other.dataType &&
          columnDescription == other.columnDescription &&
          mode == other.mode;

  @override
  int get hashcode =>
      columnName.hashCode ^
      dataType.hashCode ^
      mode.hashCode ^
      columnDescription.hashCode;

  factory ColumnFileds.fromJson(Map<String, dynamic> json) {
    return ColumnFileds(
      columnName: json['column_name'],
      dataType: json['data_type'],
      columnDescription: json['column_description'],
      mode: json['mode'],
      columnId: json['column_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['column_name'] = this.columnName;
    data['data_type'] = this.dataType;
    data['column_description'] = this.columnDescription;
    data['mode'] = this.mode;
    data['column_id'] = this.columnId;
    return data;
  }
}
