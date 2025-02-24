import 'package:equatable/equatable.dart';

import '../constants/enum.dart';

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaginationParams extends Equatable {
  final int page;
  final int limit;
  final PaginationOrder? order;

  const PaginationParams({
    required this.page,
    required this.limit,
    this.order = PaginationOrder.desc,
  });

  @override
  List<Object?> get props => [page, limit];
}

class PaginationWithSearchParams extends PaginationParams {
  final String search;

  const PaginationWithSearchParams({
    required super.page,
    required super.limit,
    required this.search,
  });

  @override
  List<Object?> get props => [page, limit, search];
}

class IdParams extends Equatable {
  final int id;
  const IdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class ListIdParams extends Equatable {
  final List<int> ids;
  const ListIdParams({required this.ids});

  @override
  List<Object?> get props => [ids];
}
