import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_params.freezed.dart';
part 'filter_params.g.dart';

@freezed
abstract class FilterParams with _$FilterParams {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory FilterParams({
    @Default(1) int page,
    @Default(10) int limit,
    String? query,
  }) = _FilterParams;

  const FilterParams._();
  factory FilterParams.fromJson(Map<String, dynamic> json) =>
      _$FilterParamsFromJson(json);
}
