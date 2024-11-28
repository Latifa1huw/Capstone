import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';

class CustomerStartViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  TextEditingController search = TextEditingController(text: "");
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<User>> salons = GenericCubit([]);
  GenericCubit<List<User>> searchSalonsResults = GenericCubit([]);

  getAllSalonIsUnblocked() async{
    try {
      salons.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "status", "Unblocked");
      List<User> sals = [];
      results.forEach((res){
        print( res.data());
        sals.add(User.fromJson(res.data() as Map<String, dynamic>));
      });
      salons.onUpdateData(sals);
    }catch (e){
      salons.onUpdateData([]);
      print("get all salons exception  >>>   $e");
    }
  }

  getAllSalonIsFilterLowToHigh(bool isLow) async{
    try {
      salons.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "status", "Unblocked");
      List<User> sals = [];
      results.forEach((res){
        print( res.data());
        sals.add(User.fromJson(res.data() as Map<String, dynamic>));
      });
      if(isLow){
        sals.sort((a, b) => a.name?.compareTo(b.name ?? "") ?? 0);
      }else{
        sals.sort((a, b) => b.name?.compareTo(a.name ?? "") ?? 0);
      }


        sals.sort((a, b) => b.phone?.compareTo(a.phone ?? "") ?? 0);
      salons.onUpdateData(sals);
    }catch (e){
      salons.onUpdateData([]);
      print("get all salons exception  >>>   $e");
    }
  }

  getAllSalonIsFilterRate() async{
    try {
      salons.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "status", "Unblocked");
      List<User> sals = [];
      results.forEach((res){
        print( res.data());
        sals.add(User.fromJson(res.data() as Map<String, dynamic>));
      });
      sals.sort((a, b) => b.phone?.compareTo(a.phone ?? "") ?? 0);
      salons.onUpdateData(sals);
    }catch (e){
      salons.onUpdateData([]);
      print("get all salons exception  >>>   $e");
    }
  }

  serchOnSalons(String searchText) async{
    try {
      searchSalonsResults.onLoadingState();
      print(searchText);
      List<User> sals = [];
      salons.state.data.forEach((res){
        if(res.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false){
          sals.add(res);
        }
      });
      searchSalonsResults.onUpdateData(sals);
    }catch (e){
      searchSalonsResults.onUpdateData([]);
      print("get all salons exception  >>>   $e");
    }
  }
}