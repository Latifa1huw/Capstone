import 'package:template/shared/app_size.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: AppSize.h35,
        width: AppSize.h35,
        padding: EdgeInsets.all(AppSize.h4),
        child: const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
