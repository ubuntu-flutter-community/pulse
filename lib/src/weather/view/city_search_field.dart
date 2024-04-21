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
      decoration: const InputDecoration(
        prefixIcon: Icon(
          YaruIcons.search,
          size: 15,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 35, minHeight: 30),
        contentPadding: EdgeInsets.all(8),
        filled: true,
        hintText: 'Cityname',
      ),
    );
    return textField;
  }
}
