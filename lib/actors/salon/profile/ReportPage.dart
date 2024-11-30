import 'package:flutter/material.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Reports", isBack: true),
      body: Center(
        child: Text("My Reports"),
      ),
    );
  }
}
