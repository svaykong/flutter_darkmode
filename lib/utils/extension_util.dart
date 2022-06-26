import 'dart:developer' as dev_tool show log;

extension Log on Object {
  void log(message) {
    dev_tool.log(message.toString());
  }
}
