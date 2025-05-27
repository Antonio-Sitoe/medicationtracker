import 'package:flutter/material.dart';

class KeyboardAvoidingView extends StatelessWidget {
  final KeyboardAvoidingBehavior behavior;
  final Widget child;

  const KeyboardAvoidingView({
    super.key,
    required this.behavior,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (behavior) {
      case KeyboardAvoidingBehavior.padding:
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        );
      case KeyboardAvoidingBehavior.height:
      default:
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
    }
  }
}

enum KeyboardAvoidingBehavior { padding, height }
