import 'package:flutter/material.dart';
import 'package:rebyu/admin/details.dart';


typedef _CardSelectedCallback = void Function(int?);

class _ScreenArguments {
  _ScreenArguments({
    required this.item,
    required this.selectCard,
  });

  final dynamic item;
  final _CardSelectedCallback selectCard;
}

class ExtractRouteArguments extends StatelessWidget {
  const ExtractRouteArguments({super.key});

  static const String routeName = '/detailView';

  @override
  Widget build(BuildContext context) {
    final _ScreenArguments args = ModalRoute.of(context)!.settings.arguments! as _ScreenArguments;
    return Scaffold(
      body: ItemDetailsPage(item: args.item)
    );
  }
}