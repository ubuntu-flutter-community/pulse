import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../string_x.dart';
import '../../build_context_x.dart';
import '../weather_model.dart';
import 'city_search_field.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({super.key, required this.error});

  final String error;

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedEmoji(
              widget.error.emptyCity
                  ? AnimatedEmojis.sunWithFace
                  : widget.error.cityNotFound
                      ? AnimatedEmojis.thinkingFace
                      : widget.error.invalidKey
                          ? AnimatedEmojis.disguise
                          : AnimatedEmojis.xEyes,
              size: 40,
            ),
            const SizedBox(
              height: kYaruPagePadding,
            ),
            if (widget.error.invalidKey)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        onChanged: (v) => _controller.text = v,
                        decoration: InputDecoration(
                          suffixIconConstraints: const BoxConstraints(
                            maxHeight: kYaruTitleBarItemHeight,
                            minHeight: kYaruTitleBarItemHeight,
                            minWidth: 45,
                          ),
                          suffixIcon: Tooltip(
                            message: 'Save',
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(kYaruButtonRadius),
                                bottomRight: Radius.circular(kYaruButtonRadius),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => model.setApiKeyAndLoadWeather(
                                    _controller.text.toString(),
                                  ),
                                  child: const Center(
                                    widthFactor: 0,
                                    child: Icon(YaruIcons.save),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          errorMaxLines: 5,
                          errorText: widget.error.invalidKey
                              ? 'Please enter a valid API key'
                              : widget.error,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          fillColor: context.theme.colorScheme.surface
                              .withOpacity(0.3),
                          label: const Text('OpenWeather API key'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (widget.error.emptyCity || widget.error.cityNotFound)
              const SizedBox(
                width: 300,
                child: CitySearchField(
                  watchError: true,
                ),
              )
            else
              Text(
                widget.error,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
