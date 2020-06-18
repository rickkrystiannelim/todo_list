class TODO {
  int id = 0;
  String text;
  bool status;
  String photo;
  bool notify;

  TODO(
    this.text,
    {
      this.status = false,
      this.photo = '',
      this.notify = false
    }
  );

  /// Create a [Map] instance of this class.
  ///
  ///
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'text': this.text,
      'status': this.status,
      'photo': this.photo,
      'notify': this.notify
    };
  }

  /// Create an instance of this class based from [src] map.
  ///
  ///
  static TODO from(Map<dynamic, dynamic> src) {
    final todo = TODO(
      src["text"] as String,
      status: src["status"] as bool,
      photo: src["photo"] as String,
      notify: src["notify"] as bool
    );
    todo.id = src["id"] as int;
    return todo;
  }
}