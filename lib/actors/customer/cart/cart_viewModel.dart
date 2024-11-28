
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/cart/models/CartItem.dart';
import 'package:template/features/customer/cart/models/product.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/salon/coupons/coupon_viewModel.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class CartViewModel extends ChangeNotifier {
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<Service>?> selectServices = GenericCubit(null);
  GenericCubit<String?> selectCategoryServices = GenericCubit(null);
  GenericCubit<Coupon?> selectedCoupon = GenericCubit(null);
  GenericCubit<DateTime> selectedDate = GenericCubit(DateTime.now());
  GenericCubit<String?> selectedTime = GenericCubit(null);
  GenericCubit<List<String>> timeRanges = GenericCubit([]);

  GenericCubit<String?> locationCubit = GenericCubit(null);
  GenericCubit<String?> newLocationCubit = GenericCubit(null);
  GenericCubit<LatLng?> newPostion = GenericCubit(null);
  GenericCubit<List<Marker>> markers = GenericCubit(<Marker>[]);

  GenericCubit<int> selectedPayment = GenericCubit(0);
  GenericCubit<double> totalServicePrice = GenericCubit(0.0);
  GenericCubit<double> totalServicePriceWithoutDiscount = GenericCubit(0.0);

  TextEditingController sa = TextEditingController(text: "");
  // TextEditingController sa = TextEditingController(text: "4111 1111 1111 1111");
  TextEditingController cvc = TextEditingController(text: "");
  TextEditingController years_month = TextEditingController(text: "");

  TextEditingController discount = TextEditingController(text: "");

  // ["Request sent", "Accepted", "On the way", "Completed"]

  final formKey = GlobalKey<FormState>();

  LatLng? currentPostion;

  calcTotalServicePrice({Coupon? withcoupon}){
    totalServicePrice.onUpdateData(0.0);
    double prices = 0.0;
    selectServices.state.data!.forEach((e){
      prices += e.price!;
    });
    if(withcoupon == null){
      totalServicePriceWithoutDiscount.onUpdateData(prices);
      totalServicePrice.onUpdateData(prices);
    } else{
      // final newPrice = prices * withcoupon.discountPrecentage;
      totalServicePrice.onUpdateData(prices - withcoupon.discountPrecentage!);
    }
  }

  void checkCoupon(List<Coupon> allCoupons, String coupon) {
    for (var e in allCoupons) {
      if (e.code == coupon) {
        UI.showMessage("Coupon $coupon is valid");
        selectedCoupon.onUpdateData(e);
        calcTotalServicePrice(withcoupon: e);
        return; // Stops the function once the coupon is found
      }
    }

    // Only executed if no coupon is found
    UI.showMessage("Coupon $coupon is not valid");
  }

  orderCheckOut(User salon) async{
    String orderId = Uuid().v4(); // Generate a unique ID for the product
    OrderItem order = OrderItem();
    order.serviceData = [];
    order.customerId = PrefManager.currentUser!.id;
    order.customerData = PrefManager.currentUser;
    order.salonId = salon.id;
    order.salonData = salon;
    order.bookingId = orderId;
    order.status = "Request sent";
    order.lat = newPostion.state.data?.latitude;
    order.long = newPostion.state.data?.longitude;
    order.trackingLocation = newLocationCubit.state.data;
    order.couponId = selectedCoupon.state.data?.couponId;
    order.couponData = selectedCoupon.state.data;
    order.serviceData = selectServices.state.data;
    order.appointmentDate = selectedDate.state.data;
    order.appointmentTime = selectedTime.state.data;

    print("order.toJson()");
    print(order.toJson());
    if(order.serviceData?.isEmpty ?? false){
      UI.showMessage("Cart should have one service to checkout");
      return;
    }
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.ordersTable, orderId, order.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Order added success");
      loading.onUpdateData(false);
      UI.pushWithRemove(AppRoutes.appointmentConfirmation);
    }catch (e){
      print("add product exception  >>>   $e");
    }
  }

  List<CartItem> items = [];

  void addToCart(Product product) {
    for (var item in items) {
      if (item.product?.name == product.name) {
        item.increment();
        UI.showMessage("Increment the quantity of product success");
        notifyListeners();
        return;
      }
    }
    items.add(CartItem(product: product));
    UI.showMessage("Added to cart success");
    notifyListeners();
  }

  void removeFromCart(Product product) {
    items.removeWhere((item) => item.product?.name == product.name);
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0, (sum, item) => sum + item.product!.price! * item.quantity);


  List<String> generateTimeSlots(String startTime, String endTime) {
    // Define time format
    final timeFormat = DateFormat('hh:mm a');
    timeRanges.onLoadingState();

    // Parse the start and end time into DateTime objects
    DateTime start = timeFormat.parse(startTime);
    DateTime end = timeFormat.parse(endTime);

    List<String> timeSlots = [];

    // Loop through each hour from start to end
    while (start.isBefore(end)) {
      // Get the next hour
      DateTime nextHour = start.add(Duration(hours: 1));

      // Format the current and next hour into the desired format
      String timeSlot = "${timeFormat.format(start)} - ${timeFormat.format(nextHour)}";

      // Add the time slot to the list
      timeSlots.add(timeSlot);

      // Move to the next time slot
      start = nextHour;
    }

    timeRanges.onUpdateData(timeSlots);
    return timeSlots;
  }


  updateLocation(LatLng position) async{
    List newPlace =  await placemarkFromCoordinates(position.latitude, position.longitude);;
    Placemark placeMark  = newPlace[0];
    String compeletAddressInfor = '${placeMark.subThoroughfare} ${placeMark.thoroughfare}, ${placeMark.subLocality} ${placeMark.locality}, ${placeMark.subAdministrativeArea} ${placeMark.administrativeArea}, ${placeMark.postalCode} ${placeMark.country},';
    String specificAddress = '${placeMark.locality}, ${placeMark.country}';
    log("new locatio name $specificAddress");
    newPostion.onUpdateData(position);
    newLocationCubit.onUpdateData(compeletAddressInfor);
    locationCubit.onUpdateData(compeletAddressInfor);
    log("newPostion ${newPostion.state.data}");
    log("newLocationCubit ${newLocationCubit.state.data}");
    var mrks = [Marker(
      markerId: const MarkerId('SomeId'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(15.0),
      infoWindow: const InfoWindow(
        title: 'title',
        snippet: 'address',
      ),)];
    markers.onUpdateData(mrks);
  }


  String? validateCombinedInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter years and months (e.g., 24/6)';
    }

    // Splitting the input by forward slash '/'
    List<String> parts = value.split('/');

    if (parts.length != 2) {
      return 'Invalid format. Use Y/M (e.g., 24/6)';
    }

    // Try parsing both parts
    final int? years = int.tryParse(parts[0]);
    final int? months = int.tryParse(parts[1]);

    if (years == null || years < 0) {
      return 'Enter a valid number of years';
    }

    if (months == null || months < 1 || months > 12) {
      return 'Enter a valid number of months (1-12)';
    }

    return null; // Input is valid
  }

  String? validateCvc(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the CVC';
    }

    if (value.length < 3 || value.length > 4) {
      return 'CVC must be 3 or 4 digits';
    }

    // Ensure that the CVC contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'CVC must contain only digits';
    }

    return null; // Input is valid
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the card number';
    }

    value = value.replaceAll(' ', ''); // Remove spaces from the card number

    // Ensure that the card number contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Card number must contain only digits';
    }

    if (value.length < 13 || value.length > 19) {
      return 'Card number must be between 13 and 19 digits';
    }

    // Validate using the Luhn algorithm
    if (!_isValidLuhn(value)) {
      return 'Invalid card number';
    }

    return null; // Input is valid
  }

  // Luhn Algorithm to check if the card number is valid
  bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);

      if (alternate) {
        n *= 2;
        if (n > 9) {
          n -= 9;
        }
      }

      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

}
