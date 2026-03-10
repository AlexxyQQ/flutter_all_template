// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_crud_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BaseCrudState<Response> {

 bool get isLoading; List<Response> get entities; Response? get selectedEntity; List<Response> get selectedEntities; List<Response> get filteredEntities; Failure? get error; String get searchQuery; String? get successMessage; Object? get filters;// Pagination States
 bool get isInitial; bool get isLoadingMore; bool get hasLoadedNext; bool get isLoadingNext; bool get hasReachedNextEnd; int get currentPage; int get nextPageSize; int get previousPageSize; String? get nextToken; String? get previousToken; int? get nextPage; int? get totalPages;// Groups
 Map<String, dynamic>? get groupSelected; Map<String, List<Response>>? get groupedEntities; Map<String, List<Response>>? get groupedFilteredEntities;
/// Create a copy of BaseCrudState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseCrudStateCopyWith<Response, BaseCrudState<Response>> get copyWith => _$BaseCrudStateCopyWithImpl<Response, BaseCrudState<Response>>(this as BaseCrudState<Response>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseCrudState<Response>&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.entities, entities)&&const DeepCollectionEquality().equals(other.selectedEntity, selectedEntity)&&const DeepCollectionEquality().equals(other.selectedEntities, selectedEntities)&&const DeepCollectionEquality().equals(other.filteredEntities, filteredEntities)&&(identical(other.error, error) || other.error == error)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&const DeepCollectionEquality().equals(other.filters, filters)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasLoadedNext, hasLoadedNext) || other.hasLoadedNext == hasLoadedNext)&&(identical(other.isLoadingNext, isLoadingNext) || other.isLoadingNext == isLoadingNext)&&(identical(other.hasReachedNextEnd, hasReachedNextEnd) || other.hasReachedNextEnd == hasReachedNextEnd)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.nextPageSize, nextPageSize) || other.nextPageSize == nextPageSize)&&(identical(other.previousPageSize, previousPageSize) || other.previousPageSize == previousPageSize)&&(identical(other.nextToken, nextToken) || other.nextToken == nextToken)&&(identical(other.previousToken, previousToken) || other.previousToken == previousToken)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other.groupSelected, groupSelected)&&const DeepCollectionEquality().equals(other.groupedEntities, groupedEntities)&&const DeepCollectionEquality().equals(other.groupedFilteredEntities, groupedFilteredEntities));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,const DeepCollectionEquality().hash(entities),const DeepCollectionEquality().hash(selectedEntity),const DeepCollectionEquality().hash(selectedEntities),const DeepCollectionEquality().hash(filteredEntities),error,searchQuery,successMessage,const DeepCollectionEquality().hash(filters),isInitial,isLoadingMore,hasLoadedNext,isLoadingNext,hasReachedNextEnd,currentPage,nextPageSize,previousPageSize,nextToken,previousToken,nextPage,totalPages,const DeepCollectionEquality().hash(groupSelected),const DeepCollectionEquality().hash(groupedEntities),const DeepCollectionEquality().hash(groupedFilteredEntities)]);

@override
String toString() {
  return 'BaseCrudState<$Response>(isLoading: $isLoading, entities: $entities, selectedEntity: $selectedEntity, selectedEntities: $selectedEntities, filteredEntities: $filteredEntities, error: $error, searchQuery: $searchQuery, successMessage: $successMessage, filters: $filters, isInitial: $isInitial, isLoadingMore: $isLoadingMore, hasLoadedNext: $hasLoadedNext, isLoadingNext: $isLoadingNext, hasReachedNextEnd: $hasReachedNextEnd, currentPage: $currentPage, nextPageSize: $nextPageSize, previousPageSize: $previousPageSize, nextToken: $nextToken, previousToken: $previousToken, nextPage: $nextPage, totalPages: $totalPages, groupSelected: $groupSelected, groupedEntities: $groupedEntities, groupedFilteredEntities: $groupedFilteredEntities)';
}


}

/// @nodoc
abstract mixin class $BaseCrudStateCopyWith<Response,$Res>  {
  factory $BaseCrudStateCopyWith(BaseCrudState<Response> value, $Res Function(BaseCrudState<Response>) _then) = _$BaseCrudStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<Response> entities, Response? selectedEntity, List<Response> selectedEntities, List<Response> filteredEntities, Failure? error, String searchQuery, String? successMessage, Object? filters, bool isInitial, bool isLoadingMore, bool hasLoadedNext, bool isLoadingNext, bool hasReachedNextEnd, int currentPage, int nextPageSize, int previousPageSize, String? nextToken, String? previousToken, int? nextPage, int? totalPages, Map<String, dynamic>? groupSelected, Map<String, List<Response>>? groupedEntities, Map<String, List<Response>>? groupedFilteredEntities
});


$FailureCopyWith<$Res>? get error;

}
/// @nodoc
class _$BaseCrudStateCopyWithImpl<Response,$Res>
    implements $BaseCrudStateCopyWith<Response, $Res> {
  _$BaseCrudStateCopyWithImpl(this._self, this._then);

  final BaseCrudState<Response> _self;
  final $Res Function(BaseCrudState<Response>) _then;

/// Create a copy of BaseCrudState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? entities = null,Object? selectedEntity = freezed,Object? selectedEntities = null,Object? filteredEntities = null,Object? error = freezed,Object? searchQuery = null,Object? successMessage = freezed,Object? filters = freezed,Object? isInitial = null,Object? isLoadingMore = null,Object? hasLoadedNext = null,Object? isLoadingNext = null,Object? hasReachedNextEnd = null,Object? currentPage = null,Object? nextPageSize = null,Object? previousPageSize = null,Object? nextToken = freezed,Object? previousToken = freezed,Object? nextPage = freezed,Object? totalPages = freezed,Object? groupSelected = freezed,Object? groupedEntities = freezed,Object? groupedFilteredEntities = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,entities: null == entities ? _self.entities : entities // ignore: cast_nullable_to_non_nullable
as List<Response>,selectedEntity: freezed == selectedEntity ? _self.selectedEntity : selectedEntity // ignore: cast_nullable_to_non_nullable
as Response?,selectedEntities: null == selectedEntities ? _self.selectedEntities : selectedEntities // ignore: cast_nullable_to_non_nullable
as List<Response>,filteredEntities: null == filteredEntities ? _self.filteredEntities : filteredEntities // ignore: cast_nullable_to_non_nullable
as List<Response>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,filters: freezed == filters ? _self.filters : filters ,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasLoadedNext: null == hasLoadedNext ? _self.hasLoadedNext : hasLoadedNext // ignore: cast_nullable_to_non_nullable
as bool,isLoadingNext: null == isLoadingNext ? _self.isLoadingNext : isLoadingNext // ignore: cast_nullable_to_non_nullable
as bool,hasReachedNextEnd: null == hasReachedNextEnd ? _self.hasReachedNextEnd : hasReachedNextEnd // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,nextPageSize: null == nextPageSize ? _self.nextPageSize : nextPageSize // ignore: cast_nullable_to_non_nullable
as int,previousPageSize: null == previousPageSize ? _self.previousPageSize : previousPageSize // ignore: cast_nullable_to_non_nullable
as int,nextToken: freezed == nextToken ? _self.nextToken : nextToken // ignore: cast_nullable_to_non_nullable
as String?,previousToken: freezed == previousToken ? _self.previousToken : previousToken // ignore: cast_nullable_to_non_nullable
as String?,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,groupSelected: freezed == groupSelected ? _self.groupSelected : groupSelected // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,groupedEntities: freezed == groupedEntities ? _self.groupedEntities : groupedEntities // ignore: cast_nullable_to_non_nullable
as Map<String, List<Response>>?,groupedFilteredEntities: freezed == groupedFilteredEntities ? _self.groupedFilteredEntities : groupedFilteredEntities // ignore: cast_nullable_to_non_nullable
as Map<String, List<Response>>?,
  ));
}
/// Create a copy of BaseCrudState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [BaseCrudState].
extension BaseCrudStatePatterns<Response> on BaseCrudState<Response> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseCrudState<Response> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseCrudState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseCrudState<Response> value)  $default,){
final _that = this;
switch (_that) {
case _BaseCrudState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseCrudState<Response> value)?  $default,){
final _that = this;
switch (_that) {
case _BaseCrudState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<Response> entities,  Response? selectedEntity,  List<Response> selectedEntities,  List<Response> filteredEntities,  Failure? error,  String searchQuery,  String? successMessage,  Object? filters,  bool isInitial,  bool isLoadingMore,  bool hasLoadedNext,  bool isLoadingNext,  bool hasReachedNextEnd,  int currentPage,  int nextPageSize,  int previousPageSize,  String? nextToken,  String? previousToken,  int? nextPage,  int? totalPages,  Map<String, dynamic>? groupSelected,  Map<String, List<Response>>? groupedEntities,  Map<String, List<Response>>? groupedFilteredEntities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseCrudState() when $default != null:
return $default(_that.isLoading,_that.entities,_that.selectedEntity,_that.selectedEntities,_that.filteredEntities,_that.error,_that.searchQuery,_that.successMessage,_that.filters,_that.isInitial,_that.isLoadingMore,_that.hasLoadedNext,_that.isLoadingNext,_that.hasReachedNextEnd,_that.currentPage,_that.nextPageSize,_that.previousPageSize,_that.nextToken,_that.previousToken,_that.nextPage,_that.totalPages,_that.groupSelected,_that.groupedEntities,_that.groupedFilteredEntities);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<Response> entities,  Response? selectedEntity,  List<Response> selectedEntities,  List<Response> filteredEntities,  Failure? error,  String searchQuery,  String? successMessage,  Object? filters,  bool isInitial,  bool isLoadingMore,  bool hasLoadedNext,  bool isLoadingNext,  bool hasReachedNextEnd,  int currentPage,  int nextPageSize,  int previousPageSize,  String? nextToken,  String? previousToken,  int? nextPage,  int? totalPages,  Map<String, dynamic>? groupSelected,  Map<String, List<Response>>? groupedEntities,  Map<String, List<Response>>? groupedFilteredEntities)  $default,) {final _that = this;
switch (_that) {
case _BaseCrudState():
return $default(_that.isLoading,_that.entities,_that.selectedEntity,_that.selectedEntities,_that.filteredEntities,_that.error,_that.searchQuery,_that.successMessage,_that.filters,_that.isInitial,_that.isLoadingMore,_that.hasLoadedNext,_that.isLoadingNext,_that.hasReachedNextEnd,_that.currentPage,_that.nextPageSize,_that.previousPageSize,_that.nextToken,_that.previousToken,_that.nextPage,_that.totalPages,_that.groupSelected,_that.groupedEntities,_that.groupedFilteredEntities);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<Response> entities,  Response? selectedEntity,  List<Response> selectedEntities,  List<Response> filteredEntities,  Failure? error,  String searchQuery,  String? successMessage,  Object? filters,  bool isInitial,  bool isLoadingMore,  bool hasLoadedNext,  bool isLoadingNext,  bool hasReachedNextEnd,  int currentPage,  int nextPageSize,  int previousPageSize,  String? nextToken,  String? previousToken,  int? nextPage,  int? totalPages,  Map<String, dynamic>? groupSelected,  Map<String, List<Response>>? groupedEntities,  Map<String, List<Response>>? groupedFilteredEntities)?  $default,) {final _that = this;
switch (_that) {
case _BaseCrudState() when $default != null:
return $default(_that.isLoading,_that.entities,_that.selectedEntity,_that.selectedEntities,_that.filteredEntities,_that.error,_that.searchQuery,_that.successMessage,_that.filters,_that.isInitial,_that.isLoadingMore,_that.hasLoadedNext,_that.isLoadingNext,_that.hasReachedNextEnd,_that.currentPage,_that.nextPageSize,_that.previousPageSize,_that.nextToken,_that.previousToken,_that.nextPage,_that.totalPages,_that.groupSelected,_that.groupedEntities,_that.groupedFilteredEntities);case _:
  return null;

}
}

}

/// @nodoc


class _BaseCrudState<Response> extends BaseCrudState<Response> {
  const _BaseCrudState({this.isLoading = false, final  List<Response> entities = const [], this.selectedEntity, final  List<Response> selectedEntities = const [], final  List<Response> filteredEntities = const [], this.error, this.searchQuery = '', this.successMessage, this.filters, this.isInitial = true, this.isLoadingMore = false, this.hasLoadedNext = false, this.isLoadingNext = false, this.hasReachedNextEnd = false, this.currentPage = 1, this.nextPageSize = 10, this.previousPageSize = 10, this.nextToken, this.previousToken, this.nextPage, this.totalPages, final  Map<String, dynamic>? groupSelected, final  Map<String, List<Response>>? groupedEntities, final  Map<String, List<Response>>? groupedFilteredEntities}): _entities = entities,_selectedEntities = selectedEntities,_filteredEntities = filteredEntities,_groupSelected = groupSelected,_groupedEntities = groupedEntities,_groupedFilteredEntities = groupedFilteredEntities,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<Response> _entities;
@override@JsonKey() List<Response> get entities {
  if (_entities is EqualUnmodifiableListView) return _entities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entities);
}

@override final  Response? selectedEntity;
 final  List<Response> _selectedEntities;
@override@JsonKey() List<Response> get selectedEntities {
  if (_selectedEntities is EqualUnmodifiableListView) return _selectedEntities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedEntities);
}

 final  List<Response> _filteredEntities;
@override@JsonKey() List<Response> get filteredEntities {
  if (_filteredEntities is EqualUnmodifiableListView) return _filteredEntities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredEntities);
}

@override final  Failure? error;
@override@JsonKey() final  String searchQuery;
@override final  String? successMessage;
@override final  Object? filters;
// Pagination States
@override@JsonKey() final  bool isInitial;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasLoadedNext;
@override@JsonKey() final  bool isLoadingNext;
@override@JsonKey() final  bool hasReachedNextEnd;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int nextPageSize;
@override@JsonKey() final  int previousPageSize;
@override final  String? nextToken;
@override final  String? previousToken;
@override final  int? nextPage;
@override final  int? totalPages;
// Groups
 final  Map<String, dynamic>? _groupSelected;
// Groups
@override Map<String, dynamic>? get groupSelected {
  final value = _groupSelected;
  if (value == null) return null;
  if (_groupSelected is EqualUnmodifiableMapView) return _groupSelected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, List<Response>>? _groupedEntities;
@override Map<String, List<Response>>? get groupedEntities {
  final value = _groupedEntities;
  if (value == null) return null;
  if (_groupedEntities is EqualUnmodifiableMapView) return _groupedEntities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, List<Response>>? _groupedFilteredEntities;
@override Map<String, List<Response>>? get groupedFilteredEntities {
  final value = _groupedFilteredEntities;
  if (value == null) return null;
  if (_groupedFilteredEntities is EqualUnmodifiableMapView) return _groupedFilteredEntities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of BaseCrudState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseCrudStateCopyWith<Response, _BaseCrudState<Response>> get copyWith => __$BaseCrudStateCopyWithImpl<Response, _BaseCrudState<Response>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseCrudState<Response>&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._entities, _entities)&&const DeepCollectionEquality().equals(other.selectedEntity, selectedEntity)&&const DeepCollectionEquality().equals(other._selectedEntities, _selectedEntities)&&const DeepCollectionEquality().equals(other._filteredEntities, _filteredEntities)&&(identical(other.error, error) || other.error == error)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&const DeepCollectionEquality().equals(other.filters, filters)&&(identical(other.isInitial, isInitial) || other.isInitial == isInitial)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasLoadedNext, hasLoadedNext) || other.hasLoadedNext == hasLoadedNext)&&(identical(other.isLoadingNext, isLoadingNext) || other.isLoadingNext == isLoadingNext)&&(identical(other.hasReachedNextEnd, hasReachedNextEnd) || other.hasReachedNextEnd == hasReachedNextEnd)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.nextPageSize, nextPageSize) || other.nextPageSize == nextPageSize)&&(identical(other.previousPageSize, previousPageSize) || other.previousPageSize == previousPageSize)&&(identical(other.nextToken, nextToken) || other.nextToken == nextToken)&&(identical(other.previousToken, previousToken) || other.previousToken == previousToken)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&const DeepCollectionEquality().equals(other._groupSelected, _groupSelected)&&const DeepCollectionEquality().equals(other._groupedEntities, _groupedEntities)&&const DeepCollectionEquality().equals(other._groupedFilteredEntities, _groupedFilteredEntities));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,const DeepCollectionEquality().hash(_entities),const DeepCollectionEquality().hash(selectedEntity),const DeepCollectionEquality().hash(_selectedEntities),const DeepCollectionEquality().hash(_filteredEntities),error,searchQuery,successMessage,const DeepCollectionEquality().hash(filters),isInitial,isLoadingMore,hasLoadedNext,isLoadingNext,hasReachedNextEnd,currentPage,nextPageSize,previousPageSize,nextToken,previousToken,nextPage,totalPages,const DeepCollectionEquality().hash(_groupSelected),const DeepCollectionEquality().hash(_groupedEntities),const DeepCollectionEquality().hash(_groupedFilteredEntities)]);

@override
String toString() {
  return 'BaseCrudState<$Response>(isLoading: $isLoading, entities: $entities, selectedEntity: $selectedEntity, selectedEntities: $selectedEntities, filteredEntities: $filteredEntities, error: $error, searchQuery: $searchQuery, successMessage: $successMessage, filters: $filters, isInitial: $isInitial, isLoadingMore: $isLoadingMore, hasLoadedNext: $hasLoadedNext, isLoadingNext: $isLoadingNext, hasReachedNextEnd: $hasReachedNextEnd, currentPage: $currentPage, nextPageSize: $nextPageSize, previousPageSize: $previousPageSize, nextToken: $nextToken, previousToken: $previousToken, nextPage: $nextPage, totalPages: $totalPages, groupSelected: $groupSelected, groupedEntities: $groupedEntities, groupedFilteredEntities: $groupedFilteredEntities)';
}


}

/// @nodoc
abstract mixin class _$BaseCrudStateCopyWith<Response,$Res> implements $BaseCrudStateCopyWith<Response, $Res> {
  factory _$BaseCrudStateCopyWith(_BaseCrudState<Response> value, $Res Function(_BaseCrudState<Response>) _then) = __$BaseCrudStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<Response> entities, Response? selectedEntity, List<Response> selectedEntities, List<Response> filteredEntities, Failure? error, String searchQuery, String? successMessage, Object? filters, bool isInitial, bool isLoadingMore, bool hasLoadedNext, bool isLoadingNext, bool hasReachedNextEnd, int currentPage, int nextPageSize, int previousPageSize, String? nextToken, String? previousToken, int? nextPage, int? totalPages, Map<String, dynamic>? groupSelected, Map<String, List<Response>>? groupedEntities, Map<String, List<Response>>? groupedFilteredEntities
});


@override $FailureCopyWith<$Res>? get error;

}
/// @nodoc
class __$BaseCrudStateCopyWithImpl<Response,$Res>
    implements _$BaseCrudStateCopyWith<Response, $Res> {
  __$BaseCrudStateCopyWithImpl(this._self, this._then);

  final _BaseCrudState<Response> _self;
  final $Res Function(_BaseCrudState<Response>) _then;

/// Create a copy of BaseCrudState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? entities = null,Object? selectedEntity = freezed,Object? selectedEntities = null,Object? filteredEntities = null,Object? error = freezed,Object? searchQuery = null,Object? successMessage = freezed,Object? filters = freezed,Object? isInitial = null,Object? isLoadingMore = null,Object? hasLoadedNext = null,Object? isLoadingNext = null,Object? hasReachedNextEnd = null,Object? currentPage = null,Object? nextPageSize = null,Object? previousPageSize = null,Object? nextToken = freezed,Object? previousToken = freezed,Object? nextPage = freezed,Object? totalPages = freezed,Object? groupSelected = freezed,Object? groupedEntities = freezed,Object? groupedFilteredEntities = freezed,}) {
  return _then(_BaseCrudState<Response>(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,entities: null == entities ? _self._entities : entities // ignore: cast_nullable_to_non_nullable
as List<Response>,selectedEntity: freezed == selectedEntity ? _self.selectedEntity : selectedEntity // ignore: cast_nullable_to_non_nullable
as Response?,selectedEntities: null == selectedEntities ? _self._selectedEntities : selectedEntities // ignore: cast_nullable_to_non_nullable
as List<Response>,filteredEntities: null == filteredEntities ? _self._filteredEntities : filteredEntities // ignore: cast_nullable_to_non_nullable
as List<Response>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,filters: freezed == filters ? _self.filters : filters ,isInitial: null == isInitial ? _self.isInitial : isInitial // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasLoadedNext: null == hasLoadedNext ? _self.hasLoadedNext : hasLoadedNext // ignore: cast_nullable_to_non_nullable
as bool,isLoadingNext: null == isLoadingNext ? _self.isLoadingNext : isLoadingNext // ignore: cast_nullable_to_non_nullable
as bool,hasReachedNextEnd: null == hasReachedNextEnd ? _self.hasReachedNextEnd : hasReachedNextEnd // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,nextPageSize: null == nextPageSize ? _self.nextPageSize : nextPageSize // ignore: cast_nullable_to_non_nullable
as int,previousPageSize: null == previousPageSize ? _self.previousPageSize : previousPageSize // ignore: cast_nullable_to_non_nullable
as int,nextToken: freezed == nextToken ? _self.nextToken : nextToken // ignore: cast_nullable_to_non_nullable
as String?,previousToken: freezed == previousToken ? _self.previousToken : previousToken // ignore: cast_nullable_to_non_nullable
as String?,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int?,totalPages: freezed == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int?,groupSelected: freezed == groupSelected ? _self._groupSelected : groupSelected // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,groupedEntities: freezed == groupedEntities ? _self._groupedEntities : groupedEntities // ignore: cast_nullable_to_non_nullable
as Map<String, List<Response>>?,groupedFilteredEntities: freezed == groupedFilteredEntities ? _self._groupedFilteredEntities : groupedFilteredEntities // ignore: cast_nullable_to_non_nullable
as Map<String, List<Response>>?,
  ));
}

/// Create a copy of BaseCrudState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
