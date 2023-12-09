class State<T> {
  State({
    this.data,
    this.error,
  });
  T? data;
  dynamic error;
  
  bool get hasData => data == null ? false : true;
  bool get hasError => error == null ? false : true;
}
