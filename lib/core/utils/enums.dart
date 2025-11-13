// ignore_for_file: constant_identifier_names

enum ErrorLevels {
  DEBUG,
  INFO,
  ERROR,
  CRITICAL,
}

enum ENGameQuestionStatus {
  Answer,
  Question,
  ChoseTeam,
}

enum APIState {
  prod,
  dev,
}

enum MediaType { audio, video, image, error }

enum ProductSortBy {
  name,
  price,
  createdAt,
  stockQuantity,
}

extension ProductSortByValue on ProductSortBy {
  String get value {
    switch (this) {
      case ProductSortBy.name:
        return 'name';
      case ProductSortBy.price:
        return 'price';
      case ProductSortBy.createdAt:
        return 'created_at';
      case ProductSortBy.stockQuantity:
        return 'stock_quantity';
    }
  }
}

enum SortOrder {
  asc,
  desc,
}

extension SortOrderValue on SortOrder {
  String get value {
    switch (this) {
      case SortOrder.asc:
        return 'asc';
      case SortOrder.desc:
        return 'desc';
    }
  }
}

enum PaymentOptionType { saved, cod }
