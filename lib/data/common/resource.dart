enum Status { Loading, Success, Error }

class Resource<T> {
  final Status status;
  final T? data;
  final String? message;
  final int? responseCode;

  Resource.loading() : status = Status.Loading, data = null, message = null, responseCode = null;
  Resource.success(this.data) : status = Status.Success, message = null, responseCode = null;
  Resource.error(this.message, {this.responseCode}) : status = Status.Error, data = null;
}
