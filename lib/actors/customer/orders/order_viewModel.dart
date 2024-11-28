
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:template/features/customer/orders/models/order.dart';
import 'package:template/features/salon/coupons/models/coupon.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/models/failure.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';

class OrderViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<String> status = GenericCubit("Request sent");
  GenericCubit<List<OrderItem>> orders = GenericCubit([]);
  GenericCubit<List<OrderItem>> ordersRequesrSend = GenericCubit([]);
  GenericCubit<List<OrderItem>> ordersAccepted = GenericCubit([]);
  GenericCubit<List<OrderItem>> ordersOnTheWay = GenericCubit([]);
  GenericCubit<List<OrderItem>> ordersCompleted = GenericCubit([]);
  GenericCubit<List<OrderItem>> ordersReject = GenericCubit([]);

  String generateGoogleMapsLink(double latitude, double longitude) {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }


  List<String> statuses = ["Request sent", "Accepted", "On the way", "Completed", "Reject"];

  calcTotalServicePrice(List<Service> services, {Coupon? withcoupon}){
    double prices = 0.0;
    services.forEach((e){
      prices += e.price!;
    });
    if(withcoupon == null){
      return prices;
    } else{
      // final newPrice = prices * withcoupon.discountPrecentage;
     return (prices - withcoupon.discountPrecentage!);
    }
  }

  getOrdersProductsForEveryUserID() async{
    try {
      orders.onLoadingState();
      ordersRequesrSend.onLoadingState();
      ordersAccepted.onLoadingState();
      ordersOnTheWay.onLoadingState();
      ordersCompleted.onLoadingState();
      ordersReject.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ordersTable, "customer_id", PrefManager.currentUser!.id);
      List<OrderItem> ords = [];

      results.forEach((res){
        Logger().d(res.data());
        ords.add(OrderItem.fromJson(res.data() as Map<String, dynamic>));
      });
      List<OrderItem> ords1 = [];
      List<OrderItem> ords2 = [];
      List<OrderItem> ords3 = [];
      List<OrderItem> ords4 = [];
      List<OrderItem> ords5 = [];
      ords.forEach((e){
        if(e.status == "Request sent"){
          ords1.add(e);
        }
        if(e.status == "Accepted"){
          ords2.add(e);
        }
        if(e.status == "On the way"){
          ords3.add(e);
        }
        if(e.status == "Completed"){
          ords4.add(e);
        }
        if(e.status == "Reject"){
          ords5.add(e);
        }
      });
      orders.onUpdateData(ords);
      ordersRequesrSend.onUpdateData(ords1);
      ordersAccepted.onUpdateData(ords2);
      ordersOnTheWay.onUpdateData(ords3);
      ordersCompleted.onUpdateData(ords4);
      ordersReject.onUpdateData(ords5);
    }catch (e){
      orders.onUpdateData([]);
      ordersRequesrSend.onUpdateData([]);
      ordersAccepted.onUpdateData([]);
      ordersOnTheWay.onUpdateData([]);
      ordersCompleted.onUpdateData([]);
      ordersReject.onUpdateData([]);
      Logger().d(e);
      print("get orders exception  >>>   $e");
    }
  }

  getOrdersProductsForEverySalonID() async{
    try {
      orders.onLoadingState();
      ordersRequesrSend.onLoadingState();
      ordersAccepted.onLoadingState();
      ordersOnTheWay.onLoadingState();
      ordersCompleted.onLoadingState();
      ordersReject.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ordersTable, "salon_id", PrefManager.currentUser!.id);
      List<OrderItem> ords = [];

      results.forEach((res){
        Logger().d(res.data());
        ords.add(OrderItem.fromJson(res.data() as Map<String, dynamic>));
      });
      List<OrderItem> ords1 = [];
      List<OrderItem> ords2 = [];
      List<OrderItem> ords3 = [];
      List<OrderItem> ords4 = [];
      List<OrderItem> ords5 = [];
      ords.forEach((e){
        if(e.status == "Request sent"){
          ords1.add(e);
        }
        if(e.status == "Accepted"){
          ords2.add(e);
        }
        if(e.status == "On the way"){
          ords3.add(e);
        }
        if(e.status == "Completed"){
          ords4.add(e);
        }
        if(e.status == "Reject"){
          ords5.add(e);
        }
      });
      orders.onUpdateData(ords);
      ordersRequesrSend.onUpdateData(ords1);
      ordersAccepted.onUpdateData(ords2);
      ordersOnTheWay.onUpdateData(ords3);
      ordersCompleted.onUpdateData(ords4);
      ordersReject.onUpdateData(ords5);
    }catch (e){
      orders.onUpdateData([]);
      ordersRequesrSend.onUpdateData([]);
      ordersAccepted.onUpdateData([]);
      ordersOnTheWay.onUpdateData([]);
      ordersCompleted.onUpdateData([]);
      ordersReject.onUpdateData([]);
      Logger().d(e);
      print("get orders exception  >>>   $e");
    }
  }


  getOrdersProductsBySalonID(String salonId) async{
    try {
      orders.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ordersTable, "salon_id", salonId);
      List<OrderItem> ords = [];

      results.forEach((res){
        Logger().d(res.data());
        ords.add(OrderItem.fromJson(res.data() as Map<String, dynamic>));
      });
      orders.onUpdateData(ords);
    }catch (e){
      orders.onUpdateData([]);
      Logger().d(e);
      print("get orders exception  >>>   $e");
    }
  }

  getAllOrders() async{
    try {
      orders.onLoadingState();
      ordersRequesrSend.onLoadingState();
      ordersAccepted.onLoadingState();
      ordersOnTheWay.onLoadingState();
      ordersCompleted.onLoadingState();
      ordersReject.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.ordersTable);
      List<OrderItem> ords = [];

      results.forEach((res){
        Logger().d(res.data());
        ords.add(OrderItem.fromJson(res.data() as Map<String, dynamic>));
      });
      List<OrderItem> ords1 = [];
      List<OrderItem> ords2 = [];
      List<OrderItem> ords3 = [];
      List<OrderItem> ords4 = [];
      List<OrderItem> ords5 = [];
      ords.forEach((e){
        if(e.status == "Request sent"){
          ords1.add(e);
        }
        if(e.status == "Accepted"){
          ords2.add(e);
        }
        if(e.status == "On the way"){
          ords3.add(e);
        }
        if(e.status == "Completed"){
          ords4.add(e);
        }
        if(e.status == "Reject"){
          ords5.add(e);
        }
      });
      orders.onUpdateData(ords);
      ordersRequesrSend.onUpdateData(ords1);
      ordersAccepted.onUpdateData(ords2);
      ordersOnTheWay.onUpdateData(ords3);
      ordersCompleted.onUpdateData(ords4);
      ordersReject.onUpdateData(ords5);
    }catch (e){
      orders.onUpdateData([]);
      ordersRequesrSend.onUpdateData([]);
      ordersAccepted.onUpdateData([]);
      ordersOnTheWay.onUpdateData([]);
      ordersCompleted.onUpdateData([]);
      ordersReject.onUpdateData([]);
      Logger().d(e);
      print("get orders exception  >>>   $e");
    }
  }

  updateOrderStatus(OrderItem order) async{
    try{
      loading.onUpdateData(true);
      order.status = status.state.data;
      print("user.get() >>>>  ${order.toJson()}");

      await firebaseHelper.updateDocument(CollectionNames.ordersTable, order.bookingId ?? "", order.toJson());
      if(PrefManager.currentUser?.type == 2) {
        getOrdersProductsForEveryUserID();
      }
      if(PrefManager.currentUser?.type == 1) {
        getAllOrders();
      }
      if(PrefManager.currentUser?.type == 3) {
        getOrdersProductsForEverySalonID();
      }
      loading.onUpdateData(false);
    } on Failure catch (e) {
      loading.onUpdateData(false);
      loading.onErrorState(e);
    }
  }

  updateOrderRating(OrderItem order) async{
    try{
      loading.onUpdateData(true);
      order.rated = true;
      print("user.get() >>>>  ${order.toJson()}");

      await firebaseHelper.updateDocument(CollectionNames.ordersTable, order.bookingId ?? "", order.toJson());
      if(PrefManager.currentUser?.type == 2) {
        getOrdersProductsForEveryUserID();
      }
      if(PrefManager.currentUser?.type == 1) {
        getAllOrders();
      }
      if(PrefManager.currentUser?.type == 3) {
        getOrdersProductsForEverySalonID();
      }
      loading.onUpdateData(false);
    } on Failure catch (e) {
      loading.onUpdateData(false);
      loading.onErrorState(e);
    }
  }

}