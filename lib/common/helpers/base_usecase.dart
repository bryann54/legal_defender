import 'package:legal_defender/core/errors/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type?>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchParams extends Equatable {
  final int? page;
  final int? size;
  final String? merchant;
  final int? category;
  final String? query;

  const FetchParams(
      {this.page, this.size, this.query, this.merchant, this.category});

  @override
  List<Object?> get props => [page, size, query];

  @override
  String toString() {
    return 'FetchParams(page: $page, size: $size, query: $query, category: $category, merchant: $merchant)';
  }
}
