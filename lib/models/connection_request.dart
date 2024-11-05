class ConnectRequest {
  final String name;

  ConnectRequest({required this.name});

  factory ConnectRequest.fromJson(data) {
    final name = data["name"];
    return ConnectRequest(name: name);
  }

  Map<String, dynamic> toJson()  {
    return {
      "name": name,
    };
  }
}
