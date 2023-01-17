import 'package:weather/app/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru_icons/yaru_icons.dart';

class CitySearchField extends StatefulWidget {
  const CitySearchField({super.key, required this.underline});

  final bool underline;

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
    final model = context.watch<WeatherModel>();
    var textField = TextField(
      onSubmitted: (value) => model.init(cityName: _controller.text),
      controller: _controller,
      decoration: InputDecoration(
        prefixIcon: widget.underline
            ? null
            : const Icon(
                YaruIcons.search,
                size: 15,
              ),
        prefixIconConstraints: widget.underline
            ? null
            : const BoxConstraints(minWidth: 40, minHeight: 0),
        isDense: true,
        contentPadding: widget.underline ? null : const EdgeInsets.all(8),
        filled: !widget.underline,
        hintText: 'Cityname',
        border: widget.underline ? const UnderlineInputBorder() : null,
        enabledBorder: widget.underline
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              )
            : const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
      ),
    );
    return widget.underline
        ? textField
        : Center(
            child: SizedBox(
              width: 280,
              height: 34,
              child: textField,
            ),
          );
  }
}
