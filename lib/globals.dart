import 'dart:ui';

final String _backendProtocol = "http:";
final String _backendAddress = "192.168.1.230";
final String _backendPort = "3000";

final String backendHttpAddress =
    "$_backendProtocol//$_backendAddress:$_backendPort";

final String _wsProtocol = _backendProtocol == "http:" ? "ws:" : "wss:";
final String backendWsAddress =
    "$_wsProtocol//$_backendAddress:$_backendPort/ws";

const hoverBG = Color.fromRGBO(255, 255, 255, 0.05);
