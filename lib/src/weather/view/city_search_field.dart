import '../weather_model.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/icons.dart';

class CitySearchField extends StatefulWidget {
  const CitySearchField({
    super.key,
  });

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
    var textField = TextField(
      onSubmitted: (value) => model.init(cityName: _controller.text),
      controller: _controller,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          YaruIcons.search,
          size: 15,
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 35, minHeight: 30),
        contentPadding: const EdgeInsets.all(8),
        filled: true,
        hintText: 'Cityname',
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(40),
        ),
        fillColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      ),
    );
    return textField;
  }
}
