import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/shop/address_viewModel.dart';
import 'package:template/features/customer/shop/widgets/AddLocationWidget.dart';
import 'package:template/features/customer/shop/widgets/SelectPayment.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/extentions/string_extensions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/custom_button.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/util/ui.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class SelectLocation extends StatefulWidget {
  final User salon;
  final  CartViewModel viewModel;
  const SelectLocation({Key? key, required this.salon, required this.viewModel}) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  AddressViewModel addressViewModel = AddressViewModel();

  bool isSaved = false;

  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  final MapType _currentMapType = MapType.normal;
  double? long ;
  double? lat;
  LatLng? _lastMapPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    mapController = controller;
  }

  moveToMyLcation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        ),
      ),
    );
    setState(() {
      long = position.longitude;
      lat = position.latitude;
      _lastMapPosition = LatLng(lat!, long!);
    });
    widget.viewModel.newPostion.onUpdateData(LatLng(lat!, long!));
  }

  getCurrentLoc() async{
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      long = position.longitude;
      lat = position.latitude;
    });
    widget.viewModel.updateLocation(LatLng(lat!, long!));
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever){
        UI.showMessage(
            "Please take permissions to access the device's location");
    }
  } else {
      await getCurrentLoc();
    }
  }

  @override
  void initState() {
    _checkLocationPermission();
    addressViewModel.getAllAddressesForEveryUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('lat   ${lat}');
    print('long   ${long}');
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "Confirm \n The Location"),
      body: Container(
        decoration: const BoxDecoration(
            color: AppColors.kWhiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
            )
        ),
        height: MediaQuery.of(context).size.height - 120,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0.sp),
        child: Column(
          children: [
            Row(
              children: [
                Text("My address", style: AppStyles.kTextStyleHeader20,textAlign: TextAlign.start,),
              ],
            ),
            BlocBuilder<GenericCubit<List<Marker>>,
                GenericCubitState<List<Marker>>>(
                bloc: widget.viewModel.markers,
                builder: (context, state) {
                  return  state is GenericLoadingState?
                  const Loading():
                  Container(
                    height: 300.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.kMainColor, width: 4)
                    ),
                    child: lat == null && long == null ?  const Loading(): GoogleMap(
                      mapToolbarEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat!, long!),
                        zoom: 16.4746,
                      ),
                      mapType: _currentMapType,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      trafficEnabled: true,
                      myLocationButtonEnabled: true,
                      scrollGesturesEnabled: true,
                      markers: Set<Marker>.of(state.data),
                      onCameraMove: (CameraPosition position) {
                        _lastMapPosition = position.target;
                      },
                      onTap: (p){
                        widget.viewModel.updateLocation(p);
                      },
                    ),
                  );
                }
            ),
            AppSize.h30.ph,
            Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.kBlackColor),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<GenericCubit<String?>,
                      GenericCubitState<String?>>(
                      bloc: widget.viewModel.newLocationCubit,
                      builder: (context, state) {
                        return  state is GenericLoadingState?
                        const Loading():
                        Expanded(child: Text(state.data ?? "Select Location".tr(),maxLines: 20, style: AppStyles.kTextStyle14,));
                      }
                  ),
                  AppSize.h5.pw,
                  Image.asset(Resources.done, height: 25, width: 20,),
                ],
              ),
            ),
            AppSize.h20.ph,

            BlocBuilder<GenericCubit<String?>,
                GenericCubitState<String?>>(
                bloc: widget.viewModel.newLocationCubit,
                builder: (context, state) {
                  return  state is GenericLoadingState?
                  const Loading():
                  Row(
                    children: [
                      Switch(value: isSaved, onChanged: (v){
                        setState(() {
                          isSaved = !isSaved;
                        });
                      if(v){
                        addressViewModel.location_name.text = state.data?.split(",").last == "" ? "My Location" : (state.data?.split(",").last ?? "");
                        addressViewModel.description.text = state.data ?? "";
                        addressViewModel.addLocation();
                      }
                      }),
                      Text("If you want to save this address click Here", style: AppStyles.kTextStyleHeader14,)
                    ],
                  );
              }
            ),

            AppSize.h40.ph,
            InkWell(
                onTap: (){
                  _checkLocationPermission();

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSize.r30),
                        topRight: Radius.circular(AppSize.r30),
                      ),
                    ),
                    builder: (_) => Container(
                        height: AppSize.h350,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSize.r30),
                            topRight: Radius.circular(AppSize.r30),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: AddLocationWidget(addressViewModel: addressViewModel, viewModel: widget.viewModel,)
                    ),
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.kMainColor, width: 2)
                    ),
                    padding: EdgeInsets.all(10.sp),
                    child: Text("Saved Addresses", style: AppStyles.kTextStyleHeader18,textAlign: TextAlign.start,))),
            AppSize.h10.ph,
            BlocBuilder<GenericCubit<LatLng?>,
                GenericCubitState<LatLng?>>(
                bloc: widget.viewModel.newPostion,
                builder: (context, state) {
                  return  state is GenericLoadingState?
                  const Loading():
                  CustomButton(
                      title: "Next".tr(),
                      width: 150.sp,
                      onClick: (){
                        widget.viewModel.updateLocation(state.data!);
                        if(widget.viewModel.newLocationCubit.state.data != null || widget.viewModel.newPostion.state.data != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SelectPayment(
                                salon: widget.salon,
                                cartViewModel: widget.viewModel,
                              )));
                        }else{
                          UI.showMessage("Should select location to complete");
                        }
                      });
                }
            ),
            AppSize.h30.ph,
          ],
        ),
      ),
    );
  }
}