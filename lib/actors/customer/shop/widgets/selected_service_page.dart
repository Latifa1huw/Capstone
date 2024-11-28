import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/shop/widgets/ServiceCard.dart';
import 'package:template/features/salon/services/models/service.dart';

class SelectedServicePage extends StatefulWidget {
  final List<Service> services;
  final CartViewModel cartViewModel;
  const SelectedServicePage({Key? key, required this.services, required this.cartViewModel}) : super(key: key);

  @override
  State<SelectedServicePage> createState() => _SelectedServicePageState();
}

class _SelectedServicePageState extends State<SelectedServicePage> {
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ListView.builder(
          itemCount: widget.services.length,
          itemBuilder: (context, index){
        final service = widget.services[index];
        return ServiceCard(service: service, cartViewModel: widget.cartViewModel,);
      }),
    );

  //   return GridView.builder(
  //     shrinkWrap: true,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2, // Two elements per row
  //       crossAxisSpacing: 10.sp, // Spacing between items horizontally
  //       mainAxisSpacing: 10.sp, // Spacing between items vertically
  //       childAspectRatio: 2.4, // Adjust aspect ratio for a good layout
  //     ),
  //     padding: EdgeInsets.all(10),
  //     itemCount: widget.services.length,
  //     itemBuilder: (context, index) {
  //       final service = widget.services[index];
  //       return ServiceCard(service: service, cartViewModel: widget.cartViewModel,);
  //     },
  //   );
  }
}

class SelectedServicesForAppointmentDetails extends StatefulWidget {
  final List<Service> services;
  final CartViewModel cartViewModel;
  const SelectedServicesForAppointmentDetails({Key? key, required this.services, required this.cartViewModel}) : super(key: key);

  @override
  State<SelectedServicesForAppointmentDetails> createState() => _SelectedServicesForAppointmentDetailsState();
}

class _SelectedServicesForAppointmentDetailsState extends State<SelectedServicesForAppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.services.length,
        itemBuilder: (context, index){
          final service = widget.services[index];
          return ServiceCard(service: service, cartViewModel: widget.cartViewModel,);
        });
  }
}

