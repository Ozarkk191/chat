import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/services/otp_service.dart';

class PostRepository {
  final _client = OTPService();

  Future sendOTP(SendOTPParameters parameters) async {
    return await _client.post('secretChat/get-otp/',
        data: parameters, withAccessToken: false);
  }

  Future sendNotification(SendNotiParameters parameters) async {
    return await _client.post('secretChat/notification/send',
        data: parameters, withAccessToken: false);
  }
}
