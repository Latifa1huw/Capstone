import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:template/features/customer/shop/models/address.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class AddressViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();

  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<Address>> addresses = GenericCubit([]);


  TextEditingController location_name = TextEditingController(text: "");
  TextEditingController description = TextEditingController(text: "");

  final formKey = GlobalKey<FormState>();

  addLocation() async{
    // if (!formKey.currentState!.validate()){
    //   return;
    // }

    Address serv = Address();
    String serviceId = Uuid().v4(); // Generate a unique ID for the service

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);

      serv.id = serviceId;
      serv.locationName = location_name.text;
      serv.details = description.text;
      serv.customerData = PrefManager.currentUser;
      serv.customerId = PrefManager.currentUser?.id;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.addressesTable, serviceId, serv.toJson());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Address added success");
      loading.onUpdateData(false);
      getAllAddressesForEveryUserID();
    }catch (e){
      loading.onUpdateData(false);
      print("add address exception  >>>   $e");
    }
  }

  deleteAddress(String addressId) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      await firebaseHelper.deleteDocument(CollectionNames.addressesTable, addressId);
      UI.showMessage("Service deleted success");
      getAllAddressesForEveryUserID();
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("delete service exception  >>>   $e");
    }
  }

  getAllAddressesForEveryUserID() async{
    try {
      addresses.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.addressesTable, "customer_id", PrefManager.currentUser!.id);
      List<Address> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Address.fromJson(res.data() as Map<String, dynamic>));
      });
      addresses.onUpdateData(servs);
    }catch (e){
      addresses.onUpdateData([]);
      print("get address exception  >>>   $e");
    }
  }


}