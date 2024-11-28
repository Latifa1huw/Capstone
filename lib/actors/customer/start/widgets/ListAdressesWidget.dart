import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/customer/orders/order_viewModel.dart';
import 'package:template/features/customer/shop/address_viewModel.dart';
import 'package:template/features/customer/shop/models/address.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';


class ListAdressesWidget extends StatefulWidget {
  const ListAdressesWidget({Key? key}) : super(key: key);

  @override
  State<ListAdressesWidget> createState() => _ListAdressesWidgetState();
}

class _ListAdressesWidgetState extends State<ListAdressesWidget> {
  AddressViewModel viewModel = AddressViewModel();

  @override
  void initState() {
    viewModel.getAllAddressesForEveryUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "My Addresses", isBack: true),
      body: BlocBuilder<GenericCubit<List<Address>>,
          GenericCubitState<List<Address>>>(
          bloc: viewModel.addresses,
          // buildWhen: (context, state){
          //   var addresses = state.data;
          //   addresses.forEach((e) {
          //     if (e.trackingLocation != null) {
          //       if (!newAdresses.contains(e.trackingLocation!)) {
          //         newAdresses.add(e.trackingLocation ?? "");
          //       }
          //     }
          //   });
          //   return true;
          // },
          builder: (context, state) {
            // if(isAdresses == false){

            // }
            // isAdresses = true;
            return state is GenericLoadingState ?
            const Loading()
                : state.data.isEmpty ?
            const EmptyData()
                : ListView.builder(
              itemCount: state.data.length,
              padding: EdgeInsets.only(bottom: 150.sp),
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.sp),
                  color: AppColors.kWhiteColor,
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(state.data[index].locationName ?? "My Location", style: AppStyles.kTextStyleHeader20,)),

                            InkWell(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Note'),
                                        content: Text('Do you want to delete this address'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              UI.pop();
                                            },
                                            child: Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                viewModel.deleteAddress(state.data[index].id ?? "");
                                                state.data.removeAt(index);
                                                viewModel.addresses.onUpdateData(state.data);
                                              });
                                              UI.pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.clear, size: 30.sp,))
                          ],
                        ),
                        AppSize.h10.ph,
                        Text(state.data[index].details ?? "", style: AppStyles.kTextStyle16,),
                      ],
                    ),
                  ),
                );
              },
            );
          }
      ),
    );
  }

  Widget buildAddressCard(String locations){
    return Card(
      margin: EdgeInsets.all(10.sp),
      color: AppColors.kWhiteColor,
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text("My Location", style: AppStyles.kTextStyleHeader20,)),
                
                InkWell(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Note'),
                            content: Text('Do you want to delete this address'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  UI.pop();
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {

                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.clear, size: 30.sp,))
              ],
            ),
            AppSize.h10.ph,
            Text(locations, style: AppStyles.kTextStyle18,),
          ],
        ),
      ),
    );
  }
}
