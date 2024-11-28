import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/customer/shop/address_viewModel.dart';
import 'package:template/features/customer/shop/models/address.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';

class AddLocationWidget extends StatelessWidget {
  final AddressViewModel addressViewModel;
  final  CartViewModel viewModel;
  const AddLocationWidget({Key? key, required this.addressViewModel, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<Address>>,
        GenericCubitState<List<Address>>>(
        bloc: addressViewModel.addresses,
        builder: (context, state) {
          return state is GenericLoadingState ?
          const Loading()
              : state.data.isEmpty ?
          const EmptyData()
              : ListView.builder(
            itemCount: state.data.length,
            padding: EdgeInsets.only(bottom: 150.sp),
            itemBuilder: (context, index) {
              return  InkWell(
                  onTap: (){
                    print("tabed");
                    viewModel.updateLocation(LatLng(26.42155306395143, 50.08799761533737));
                    viewModel.newLocationCubit.onUpdateData(state.data[index].details ?? "");
                    UI.pop();
                  },
                child: Card(
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
                                               addressViewModel.deleteAddress(state.data[index].id ?? "");
                                                state.data.removeAt(index);
                                                addressViewModel.addresses.onUpdateData(state.data);
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
                ),
              );
            },
          );
        }
    );
  }
}
