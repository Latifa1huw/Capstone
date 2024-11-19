part of 'generic_cubit.dart';

abstract class GenericCubitState<T> extends Equatable {
  final T data;
  final bool changed;
  final Failure? responseError;
  const GenericCubitState({required this.data, required this.changed, this.responseError});
}

class GenericInitialState<T> extends GenericCubitState<T> {
  const GenericInitialState(T data) : super(data: data, changed: false, responseError: null);

  @override
  List<Object> get props => [changed];
}

class GenericLoadingState<T> extends GenericCubitState<T> {
  const GenericLoadingState({required T data, required bool changed}) : super(data: data, changed: changed);

  @override
  List<Object> get props => [changed];
}



class GenericUpdatedState<T> extends GenericCubitState<T> {
  const GenericUpdatedState(T data, bool changed) : super(data: data, changed: changed, responseError: null);

  @override
  List<Object> get props => [changed];
}

class GenericErrorState<T> extends GenericCubitState<T> {
  const GenericErrorState({required T data, required Failure responseError, required bool changed})
      : super(data: data, changed: changed, responseError: responseError);
  @override
  List<Object> get props => [changed];
}
