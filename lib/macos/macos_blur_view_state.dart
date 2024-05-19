/// Available blurView states (macOS only).
enum MacOSBlurViewState {
  /// The backdrop should always appear active.
  active,

  /// The backdrop should always appear inactive.
  inactive,

  /// The backdrop should automatically appear active when the window is active,
  /// and inactive when it is not.
  followsWindowActiveState
}
