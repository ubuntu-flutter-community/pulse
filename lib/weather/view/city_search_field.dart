import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../constants.dart';
import '../../extensions/build_context_x.dart';
import '../../extensions/string_x.dart';
import '../../l10n/l10n.dart';
import '../weather_model.dart';

class CitySearchField extends StatelessWidget with WatchItMixin {
  const CitySearchField({
    super.key,
    this.watchError = false,
  });

  final bool watchError;

  @override
  Widget build(BuildContext context) {
    final error = watchPropertyValue((WeatherModel m) => m.error);
    final loading = watchPropertyValue((WeatherModel m) => m.loading);

    final theme = context.theme;

    return Autocomplete<String>(
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
          TextField(
        maxLines: 1,
        autofocus: true,
        focusNode: focusNode,
        controller: controller,
        onSubmitted: (v) => di<WeatherModel>().loadWeather(cityName: v),
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.value.text.length,
          );
        },
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.2),
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
          errorText: watchError
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
          suffixIcon: loading
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
      ),
      onSelected: (o) => di<WeatherModel>().loadWeather(cityName: o),
      optionsBuilder: (v) async {
        if (v.text.isEmpty) {
          return [];
        }

        return di<WeatherModel>().findCityNames(
          v.text,
          onError: (error) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error))),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: kPaneWidth - 30,
            height: (options.length * 60) > 400 ? 400 : options.length * 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Material(
                color: theme.popupMenuTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
                elevation: 1,
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Builder(
                      builder: (BuildContext context) {
                        final bool highlight = AutocompleteHighlightedOption.of(
                              context,
                            ) ==
                            index;
                        if (highlight) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((Duration timeStamp) {
                            Scrollable.ensureVisible(
                              context,
                              alignment: 0.5,
                            );
                          });
                        }
                        final e = options.elementAt(index).split(',');

                        return ListTile(
                          title: Text(
                            (e.firstOrNull ?? '').trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            ((e.elementAtOrNull(1) ?? '') +
                                    (e.elementAtOrNull(2) ?? ''))
                                .trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => onSelected(options.elementAt(index)),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
