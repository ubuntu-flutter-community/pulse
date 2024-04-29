import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../string_x.dart';
import '../../build_context_x.dart';
import '../../l10n/l10n.dart';
import '../weather_model.dart';

class CitySearchField extends StatefulWidget with WatchItStatefulWidgetMixin {
  const CitySearchField({
    super.key,
    this.watchError = false,
  });

  final bool watchError;

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = di<WeatherModel>();
    final error = watchPropertyValue((WeatherModel m) => m.error);
    final loading = watchPropertyValue((WeatherModel m) => m.loading);

    final theme = context.theme;
    var textField = TextField(
      autofocus: true,
      onSubmitted: (value) => model.loadWeather(cityName: _controller.text),
      controller: _controller,
      onTap: () {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.value.text.length,
        );
      },
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        fillColor: theme.colorScheme.onSurface.withOpacity(0.2),
        prefixIcon: Icon(
          YaruIcons.search,
          size: 15,
          color: theme.colorScheme.onSurface,
        ),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 35, minHeight: 30),
        filled: true,
        hintText: context.l10n.cityName,
        errorText: widget.watchError
            ? (error?.cityNotFound == true
                ? context.l10n.cityNotFound
                : error?.emptyCity == true
                    ? context.l10n.enterACityName
                    : error)
            : null,
        errorMaxLines: 10,
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 20,
          minHeight: 20,
          minWidth: 20,
          maxWidth: 20,
        ),
        suffixIcon: (loading)
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox.square(
                  dimension: 20,
                  child: YaruCircularProgressIndicator(
                    color: context.theme.colorScheme.onSurface,
                    strokeWidth: 1,
                  ),
                ),
              )
            : null,
      ),
    );
    return textField;
  }
}
