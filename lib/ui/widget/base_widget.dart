import 'package:flutter/material.dart';
import 'package:flutter_funday/locator.dart';
import 'package:flutter_funday/ui/widget/base_model.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends BaseModel> extends StatefulWidget {
  const BaseWidget({
    super.key,
    required this.onModelReady,
    required this.build,
  });

  final Function(T) onModelReady;
  final Widget Function(BuildContext context, T model, Widget? child) build;

  @override
  State<BaseWidget<T>> createState() => _BaseWidgetState();
}

class _BaseWidgetState<T extends BaseModel> extends State<BaseWidget<T>> {
  T model = locator<T>();

  @override
  void initState() {
    super.initState();

    widget.onModelReady.call(model);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(builder: _consumerBuilder),
    );
  }

  Widget _consumerBuilder(BuildContext context, T value, Widget? child) {
    return widget.build(context, value, child);
  }
}
