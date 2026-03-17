import 'dart:core';

class ImLogLevel implements Comparable<ImLogLevel> {
  final String name;

  final int value;

  const ImLogLevel(this.name, this.value);

  ///打印所有的日志
  static const ImLogLevel all = ImLogLevel('ALL', 0);

  ///关闭所有日志
  static const ImLogLevel off = ImLogLevel('OFF', 2000);

  ///info 日志
  static const ImLogLevel info = ImLogLevel('INFO', 800);

  ///warning 日志
  static const ImLogLevel warning = ImLogLevel('warning', 900);

  ///error 日志
  static const ImLogLevel error = ImLogLevel('error', 1000);

  @override
  bool operator ==(Object other) => other is ImLogLevel && value == other.value;

  bool operator <(ImLogLevel other) => value < other.value;

  bool operator <=(ImLogLevel other) => value <= other.value;

  bool operator >(ImLogLevel other) => value > other.value;

  bool operator >=(ImLogLevel other) => value >= other.value;

  @override
  int compareTo(ImLogLevel other) => value - other.value;

  @override
  int get hashCode => value;

  @override
  String toString() => name;
}
