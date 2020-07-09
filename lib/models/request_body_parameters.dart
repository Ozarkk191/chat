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
