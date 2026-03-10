part of 'base_crud_bloc.dart';

abstract class BaseCrudEvent<Entity> extends Equatable {
  const BaseCrudEvent();

  @override
  List<Object?> get props => [];
}
