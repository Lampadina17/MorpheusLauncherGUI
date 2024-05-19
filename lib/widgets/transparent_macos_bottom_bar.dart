import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container.dart';
import 'package:flutter_acrylic/widgets/visual_effect_subview_container/visual_effect_subview_container_resize_event_relay.dart';

class TransparentMacOSBottomBar extends StatelessWidget {
  final Widget child;
  final double alphaValue;
  final WindowEffect effect;
  final MacOSBlurViewState state;
  final VisualEffectSubviewContainerResizeEventRelay? resizeEventRelay;

  /// A widget that applies a visual effect subview to a child widget that
  /// represents the application's bottom bar.
  ///
  /// The [alphaValue] is applied to the visual effect subview. It does not
  /// affect the opacity of the [child].
  ///
  /// By default, a [TransparentMacOSBottomBar] updates its visual effect view
  /// whenever its [build] method runs. If manual control over its update
  /// behavior is desired, it can be supplied a
  /// [VisualEffectSubviewContainerResizeEventRelay] through which its update
  /// behavior can be controlled manually.
  ///
  /// Usage example:
  /// ```dart
  /// TransparentMacOSBottomBar(
  ///   child: Container(
  ///     height: 40.0,
  ///   ),
  /// )
  /// ```
  const TransparentMacOSBottomBar({
    Key? key,
    this.alphaValue = 1.0,
    this.effect = WindowEffect.sidebar,
    this.state = MacOSBlurViewState.followsWindowActiveState,
    this.resizeEventRelay,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VisualEffectSubviewContainer(
      alphaValue: alphaValue,
      effect: effect,
      resizeEventRelay: resizeEventRelay,
      state: state,
      // Due to the fact that visual effect subviews cannot be updated while the
      // window is being resized, doing so can cause visual artifacts. To hide
      // those artifacts, the TransparentMacOSBottomBar widget adds a large
      // negative right margin to the visual effect subview.
      padding: const EdgeInsets.only(right: -7680.0),
      child: child,
    );
  }
}
