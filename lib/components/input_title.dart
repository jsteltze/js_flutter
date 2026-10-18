import 'package:flutter/material.dart';

class InputTitle extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;

  const InputTitle(this.text, {this.textAlign, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.titleSmall!
          .copyWith(color: Theme.of(context).colorScheme.primary),
    );
  }
}
