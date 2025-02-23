import 'dart:io';
import 'package:serverparking/serverHandlers/router.config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  await RouterConfig.instance.initialize();
  Router router = RouterConfig.instance.router;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');

  // ProcessSignal.sigint.watch().listen((ProcessSignal singal) {
  //   print('Shutting down');
  //   server.close(force: true);
  //   RouterConfig.instance.app.delete();
  //   exit(0);
  // )}
}
