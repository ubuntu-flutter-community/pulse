import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../../build_context_x.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return YaruDetailPage(
      appBar: YaruWindowTitleBar(
        border: BorderSide.none,
        title: const Text('Offline'),
        backgroundColor: Colors.transparent,
        leading: Navigator.of(context).canPop() == true
            ? const YaruBackButton(
                style: YaruBackButtonStyle.rounded,
              )
            : const SizedBox.shrink(),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YaruAnimatedVectorIcon(
              YaruAnimatedIcons.no_network,
              size: 200,
              color: theme.disabledColor,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: kYaruPagePadding,
                left: 40,
                right: 40,
              ),
              child: Text(
                "It look's like your computer is not connectedto the internet",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
