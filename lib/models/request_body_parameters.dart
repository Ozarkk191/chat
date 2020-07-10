abstract class RequestBodyParameters {
  // Converts the object into JSON.
  Map<String, dynamic> toJson();
}

class SendOTPParameters extends RequestBodyParameters {
  String phoneNumber;

  SendOTPParameters({this.phoneNumber});

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
      };
}

class SendNotiParameters extends RequestBodyParameters {
  String title;
  String body;
  String data;
  String token;

  SendNotiParameters({this.title, this.body, this.data, this.token});

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'data': data,
        'token': token,
      };
}
