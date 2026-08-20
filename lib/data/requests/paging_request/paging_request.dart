import 'package:freezed_annotation/freezed_annotation.dart';
part 'paging_request.freezed.dart';
part 'paging_request.g.dart';

@freezed
abstract class PagingRequest with _$PagingRequest {
  const factory PagingRequest({
    int? page,
    int? limit,
  }) = _PagingRequest;

  factory PagingRequest.fromJson(Map<String, dynamic> json) =>
      _$PagingRequestFromJson(json);
}
