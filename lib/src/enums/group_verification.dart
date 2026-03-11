import 'package:json_annotation/json_annotation.dart';

/// Group Join Verification Settings
enum GroupVerification {
  /// Apply and invite directly for entry
  @JsonValue(0)
  applyNeedVerificationInviteDirectly(0),

  /// Everyone needs verification to join, except for group owners and administrators who can invite directly
  @JsonValue(1)
  allNeedVerification(1),

  /// Directly join the group
  @JsonValue(2)
  directly(2);

  const GroupVerification(this.value);

  final int value;
}
