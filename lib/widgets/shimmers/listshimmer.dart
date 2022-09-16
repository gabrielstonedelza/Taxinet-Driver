import 'package:flutter/material.dart';
import 'package:taxinet_driver/widgets/shimmers/shimmerwidget.dart';


class ListShimmer extends StatelessWidget {
  const ListShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
        leading: ShimmerWidget.circular(width:64,height:64),
        title: ShimmerWidget.rectangular(height:16),
        subtitle: ShimmerWidget.rectangular(height:13)
    );
  }
}