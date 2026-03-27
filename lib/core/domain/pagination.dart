/// Pagination request params matching backend's dto.PaginationRequest.
class PaginationParams {
  final int page;
  final int pageSize;

  const PaginationParams({
    this.page = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toQueryParameters() => {
        'page': page,
        'page_size': pageSize,
      };

  PaginationParams nextPage() => PaginationParams(
        page: page + 1,
        pageSize: pageSize,
      );
}
