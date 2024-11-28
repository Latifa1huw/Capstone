import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/ratings/models/rating.dart';
import 'package:template/features/customer/ratings/rate_viewModel.dart';
import 'package:template/features/customer/shop/shop_interface.dart';
import 'package:template/features/customer/start/customer_start_viewModel.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';

class AvailableSalons extends StatefulWidget {
  final CustomerStartViewModel viewModel;
  final List<User> salons;
  const AvailableSalons({Key? key, required this.viewModel, required this.salons}) : super(key: key);

  @override
  State<AvailableSalons> createState() => _AvailableSalonsState();
}

class _AvailableSalonsState extends State<AvailableSalons> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          )
      ),
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.salons.length, // Replace with your dynamic data count
        itemBuilder: (context, index) {
          var salon = widget.salons.elementAt(index);
          return ShowSalonWidget(salon: salon,);
        },
      ),
    );
  }
}

class ShowSalonWidget extends StatefulWidget {
  final User salon;
  const ShowSalonWidget({Key? key, required this.salon}) : super(key: key);

  @override
  State<ShowSalonWidget> createState() => _ShowSalonWidgetState();
}

class _ShowSalonWidgetState extends State<ShowSalonWidget> {

  int totalRates = 0;
  RateViewModel rateViewModel = RateViewModel();

  getTotalRates() async{
    List<Rating> rates= await rateViewModel.getAllRateForSalonById(widget.salon.id ?? "");
    setState(() {
      totalRates = rates.length;
    });
  }

  @override
  void initState() {
    getTotalRates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      color: AppColors.kWhiteColor,
      elevation: 2,
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.salon.profile_image ?? ""), // Replace with salon logo
            radius: 30,
          ),
          title: Text(widget.salon.name ?? ""),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('★ ★ ★ ★ ☆ (${totalRates} Reviews)'),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14),
                  SizedBox(width: 5),
                  Text('${widget.salon.fromTime ?? "9:00AM"} - ${widget.salon.toTime ?? "11:00PM"}'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone, size: 14),
                  SizedBox(width: 5),
                  Text(widget.salon.phone ?? ""),
                ],
              ),
            ],
          ),
          trailing: CustomButton(
            title: "Book",
            btnColor: AppColors.kMainColor,
            width: 80.sp,
            height: 30.sp,
            textSize: 16.sp,
            textColor: AppColors.kWhiteColor,
            onClick: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ShopInterface(salon: widget.salon,))
              );
            },
          )
      ),
    );
  }
}

