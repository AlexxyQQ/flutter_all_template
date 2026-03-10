import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../config/constants/gen/locale_keys.g.dart';
import '../../../../../config/constants/type_defs/typedef.dart';
import '../../../../common/domain/entities/failure.dart';

part 'base_crud_bloc.freezed.dart';
part 'base_crud_event.dart';
part 'base_crud_state.dart';
part 'mixin/create_mixin.dart';
part 'mixin/delete_mixin.dart';
part 'mixin/filterable_crud_mixin.dart';
part 'mixin/paginated_crud_mixin.dart';
part 'mixin/read_mixin.dart';
part 'mixin/searchable_mixin.dart';
part 'mixin/selectable_mixin.dart';
part 'mixin/update_mixin.dart';

abstract class BaseCrudBloc<Entity>
    extends Bloc<BaseCrudEvent<Entity>, BaseCrudState<Entity>> {
  BaseCrudBloc({required this.name, Object? initialFilters})
    : super(BaseCrudState<Entity>(filters: initialFilters)) {}

  final String name;
  dynamic getEntityId(Entity entity);
}
