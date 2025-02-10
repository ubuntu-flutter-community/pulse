import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import '../extensions/build_context_x.dart';
import '../l10n/l10n.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruDetailPage(
      backgroundColor: Colors.transparent,
      appBar: YaruWindowTitleBar(
        border: BorderSide.none,
        title: Text(context.l10n.offline),
        backgroundColor: Colors.transparent,
        leading: Navigator.of(context).canPop() == true
            ? const YaruBackButton(
                style: YaruBackButtonStyle.rounded,
              )
            : const SizedBox.shrink(),
      ),
      body: const OfflineBody(),
    );
  }
}

class OfflineBody extends StatelessWidget {
  const OfflineBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Center(
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
              "It look's like your computer is not connected to the internet",
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
