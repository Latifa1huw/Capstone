import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/features/customer/ratings/models/rating.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/models/user_model.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class RateViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<int> rate = GenericCubit(3);
  GenericCubit<List<Rating>> ratings = GenericCubit([]);

  final formKey = GlobalKey<FormState>();

  TextEditingController comment = TextEditingController(text: "");

  addRate(User salon, String bookingId) async{
    if (!formKey.currentState!.validate()){
      return;
    }
    Rating serv = Rating();
    String rateId = Uuid().v4(); // Generate a unique ID for the service

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);

      serv.rateId = rateId;
      serv.comment = comment.text;
      serv.customerId = PrefManager.currentUser?.id;
      serv.customerData = PrefManager.currentUser;
      serv.rate = rate.state.data;
      serv.salonId = salon.id;
      serv.salonData = salon;
      serv.bookingId = bookingId;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.ratingsTable, rateId, serv.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Rate added success");
      loading.onUpdateData(false);
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("add Rate exception  >>>   $e");
    }
  }

  deleteRate(String rateId) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      await firebaseHelper.deleteDocument(CollectionNames.ratingsTable, rateId);
      UI.showMessage("Rate deleted success");
      getAllRatings();
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("delete rate exception  >>>   $e");
    }
  }

  getAllRateForEveryUserID() async{
    try {
      ratings.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ratingsTable, "salon_id", PrefManager.currentUser!.id);
      List<Rating> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Rating.fromJson(res.data() as Map<String, dynamic>));
      });
      ratings.onUpdateData(servs);
    }catch (e){
      ratings.onUpdateData([]);
      print("ratings exception  >>>   $e");
    }
  }


  getAllRateForEveryCustomerID() async{
    try {
      ratings.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ratingsTable, "customer_id", PrefManager.currentUser!.id);
      List<Rating> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Rating.fromJson(res.data() as Map<String, dynamic>));
      });
      ratings.onUpdateData(servs);
    }catch (e){
      ratings.onUpdateData([]);
      print("ratings exception  >>>   $e");
    }
  }


  Future<List<Rating>> getAllRateForSalonById(String id) async{
    try {
      ratings.onLoadingState();
      print(id);
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.ratingsTable, "salon_id", id);
      List<Rating> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Rating.fromJson(res.data() as Map<String, dynamic>));
      });
      ratings.onUpdateData(servs);
      print(servs.length);
      return servs;
    }catch (e){
      ratings.onUpdateData([]);
      print("ratings exception  >>>   $e");
      return [];
    }
  }

  getAllRatings() async{
    try {
      ratings.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.ratingsTable);
      List<Rating> servs = [];
      results.forEach((res){
        print( res.data());
        servs.add(Rating.fromJson(res.data() as Map<String, dynamic>));
      });
      ratings.onUpdateData(servs);
    }catch (e){
      ratings.onUpdateData([]);
      print("Rates exception  >>>   $e");
    }
  }

}