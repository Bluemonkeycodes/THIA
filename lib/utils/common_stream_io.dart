import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamConfig {
  // static const String apikey = "4jwj4zgux2fp";
  static const String apikey = "aw46bmah6fne";

  static const String tokenEmily =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYTUiLCJuYW1lIjoicHJhc2hhbnQiLCJpYXQiOjE1MTYyMzkwMjJ9.U-Nf-L_WOZebyB1JAtcy0ri3F5jDbAAON-UbMbYtejU';
  static const String idEmily = 'a5';

  static const String tokenPrashant =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicHJhc2hhbnQtMSIsIm5hbWUiOiJKb2huIERvZSIsImlhdCI6MTUxNjIzOTAyMn0.un1-rcJA80CAJrdu3BkdzUDJCUzJLrsCOVYFolHW0lk';
  static const String idPrashant = 'prashant-1';

  static const String tokenPeter =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYjUiLCJuYW1lIjoiQjUgQjUiLCJpYXQiOjE1MTYyMzkwMjJ9.Os9v0-7ppFC4zlDjkkPlGog8V1Kj8CeQh0Y7Dfsa1g8';
  static const String idPeter = 'b5';
}

class StreamApi {
  static Future initUser(
    StreamChatClient client, {
    required String username,
    required String urlImage,
    required String id,
    required String token,
  }) async {
    final user = User(
      id: id,
      role: "channel_member",
      extraData: {
        'name': username,
        'image': urlImage,
      },
    );
    await client.connectUser(user, token);
  }

  static Future<Channel> createChannel(
    StreamChatClient client, {
    required String type,
    required String name,
    required String id,
    required String image,
    List<String> idMembers = const [],
  }) async {
    final channel = client.channel(type, id: id, extraData: {
      'name': name,
      'image': image,
      'members': idMembers,
    });

    // await channel.create();
    await channel.watch();
    await channel.addMembers(idMembers);
    return channel;
  }

  static Future<Channel> watchChannel(
    StreamChatClient client, {
    required String type,
    required String id,
  }) async {
    final channel = client.channel(type, id: id);

    channel.watch();
    return channel;
  }
}

StreamChatClient getClient() {
  return StreamChatClient(StreamConfig.apikey, logLevel: Level.INFO);
}

// String getJwtToken({
//   required String id,
//   required String name,
// }) {
//   // Create a json web token
// // Pass the payload to be sent in the form of a map
//   final jwt = JWT(
//     // Payload
//     {'user_id': id, "name": name, "iat": Timestamp.fromDate(DateTime.now())},
//     issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
//   );
//
// // Sign it (default with HS256 algorithm)
//   String token = jwt.sign(SecretKey("fdwj77zfamwwu49a7urkvrpfp3j7aanw5gyhajvyxkeqe2vuwvnccecsmcqtkmgv"));
//
//   showLog('JWT token ===> $token\n');
//   return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaWQyIiwibmFtZSI6Im5hbWUtMiIsImlhdCI6MTUxNjIzOTAyMn0.Y12Os3zH2jdcqCcOfSGH_dTwrAFd-wy-i57uUGrBlFU";
//   // return token;
// }
