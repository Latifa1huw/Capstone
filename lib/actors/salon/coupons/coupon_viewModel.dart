
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/models/user_model.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';


class CouponViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<DateTime?> validFrom = GenericCubit(null);
  GenericCubit<DateTime?> validUntil = GenericCubit(null);
  GenericCubit<List<Coupon>> coupons = GenericCubit([]);
  GenericCubit<List<Coupon>> allCoupons = GenericCubit([]);

  final formKey = GlobalKey<FormState>();

  TextEditingController code = TextEditingController(text: "");
  TextEditingController discountPrecentage = TextEditingController(text: "");
  TextEditingController usageLimt = TextEditingController(text: "");

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (isStartDate) {
        validFrom.onUpdateData(pickedDate);
      } else {
        validUntil.onUpdateData(pickedDate);
      }
    }
  }

  addCoupon() async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(validFrom.state.data == null){
      UI.showMessage("Please select valid from time");
      return;
    }

    if(validUntil.state.data == null){
      UI.showMessage("Please select valid until time");
      return;
    }

    Coupon serv = Coupon();
    String couponId = Uuid().v4(); // Generate a unique ID for the service

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);

      serv.couponId = couponId;
      serv.code = code.text;
      serv.usageLimt = usageLimt.text;
      serv.discountPrecentage = double.parse(discountPrecentage.text);
      serv.salonId = PrefManager.currentUser?.id;
      serv.salonData = PrefManager.currentUser;
      serv.validFrom = validFrom.state.data;
      serv.validUntil = validUntil.state.data;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.couponsTable, couponId, serv.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Coupon added success");
      loading.onUpdateData(false);
      getAllCouponsForEveryUserID();
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("add coupon exception  >>>   $e");
    }
  }

  fillDate(Coupon a){
    code.text = a.code ?? "";
    discountPrecentage.text = a.discountPrecentage.toString();
    usageLimt.text = a.usageLimt ?? "";
    validFrom.onUpdateData(a.validFrom);
    validUntil.onUpdateData(a.validUntil);
  }

  clearDate(){
    code.text = "";
    discountPrecentage.text = "";
    usageLimt.text = "";
    validFrom.onUpdateData(null);
    validUntil.onUpdateData(null);
  }

  updateCoupon(String couponId) async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(validFrom.state.data == null){
      UI.showMessage("Please select valid from time");
      return;
    }

    if(validUntil.state.data == null){
      UI.showMessage("Please select valid until time");
      return;
    }

    Coupon serv = Coupon();

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);

      serv.couponId = couponId;
      serv.code = code.text;
      serv.usageLimt = usageLimt.text;
      serv.discountPrecentage = double.parse(discountPrecentage.text);
      serv.salonId = PrefManager.currentUser?.id;
      serv.salonData = PrefManager.currentUser;
      serv.validFrom = validFrom.state.data;
      serv.validUntil = validUntil.state.data;

      await firebaseHelper.updateDocument(CollectionNames.couponsTable, couponId, serv.toJson());
      UI.showMessage("Coupon updated success");
      loading.onUpdateData(false);
      getAllCouponsForEveryUserID();
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("update Coupon exception  >>>   $e");
    }
  }


 deleteCoupon(String couponId) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      await firebaseHelper.deleteDocument(CollectionNames.couponsTable, couponId);
      UI.showMessage("Coupon deleted success");
      getAllCouponsForEveryUserID();
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("delete Coupon exception  >>>   $e");
    }
  }



  getAllCouponsForEveryUserID() async{
    try {
      coupons.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.couponsTable, "salon_id", PrefManager.currentUser!.id);
      List<Coupon> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Coupon.fromJson(res.data() as Map<String, dynamic>));
      });
      coupons.onUpdateData(servs);
    }catch (e){
      coupons.onUpdateData([]);
      print("add services exception  >>>   $e");
    }
  }


 getCouponsByUserID(String id) async{
    try {
      coupons.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.couponsTable, "salon_id", id);
      List<Coupon> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Coupon.fromJson(res.data() as Map<String, dynamic>));
      });
      coupons.onUpdateData(servs);
    }catch (e){
      coupons.onUpdateData([]);
      print("add Coupon exception  >>>   $e");
    }
  }

  getAllCoupons() async{
    try {
      allCoupons.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.couponsTable);
      List<Coupon> servs = [];
      results.forEach((res){
        print( res.data());
        servs.add(Coupon.fromJson(res.data() as Map<String, dynamic>));
      });
      allCoupons.onUpdateData(servs);
    }catch (e){
      allCoupons.onUpdateData([]);
      print("add Coupon exception  >>>   $e");
    }
  }
}