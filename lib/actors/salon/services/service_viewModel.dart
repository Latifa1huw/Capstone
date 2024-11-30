import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/features/salon/services/models/service.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/helper.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class ServiceViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<File?> imageFile = GenericCubit(null);
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<String?> selectedCategory = GenericCubit(null);
  GenericCubit<String?> fromTime = GenericCubit(null);
  GenericCubit<String?> toTime = GenericCubit(null);
  GenericCubit<List<Service>> services = GenericCubit([]);
  GenericCubit<List<Service>> allservices = GenericCubit([]);
  
  List<String> categories = ["Hair Services","Hair Care", "Hair Color", "Skin treatment", "Manicure & Pedicure", "Face Care", "Massage", "Waxing", "Makeup"];
  // List<String> categories = ["Hair Styling","Manicure", "Pedicure", "Makeup"];

  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController(text: "");
  TextEditingController description = TextEditingController(text: "");
  TextEditingController price = TextEditingController(text: "");
  TextEditingController duration = TextEditingController(text: "");
  TextEditingController number_of_employees = TextEditingController(text: "");

  String imageUpdateURL = "";

  // Function to pick an image from the device
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.onUpdateData(File(pickedFile.path));
    }
  }

  addService() async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(selectedCategory.state.data == null){
      UI.showMessage("Please select category");
      return;
    }

    // if(fromTime.state.data == null){
    //   UI.showMessage("Please select from time");
    //   return;
    // }
    //
    // if(toTime.state.data == null){
    //   UI.showMessage("Please select to time");
    //   return;
    // }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Service image");
      return;
    }
    Service serv = Service();
    String serviceId = Uuid().v4(); // Generate a unique ID for the service

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      String urlProductImage = await firebaseHelper.uploadImage(
          imageFile.state.data ?? File(""));

      serv.serviceId = serviceId;
      serv.name = name.text;
      serv.description = description.text;
      serv.price = double.parse(price.text);
      serv.number_of_employees = int.parse(number_of_employees.text);
      serv.salonId = PrefManager.currentUser?.id;
      serv.availability = "${fromTime.state.data} - ${toTime.state.data}";
      serv.category = selectedCategory.state.data;
      serv.duration = duration.text;
      serv.imageUrl = urlProductImage;

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.servicesTable, serviceId, serv.toMap());
      querySnapshot?.docs.forEach((e){
        print("e.data()");
        print(e.data());
      });
      UI.showMessage("Service added success");
      loading.onUpdateData(false);
      getAllServicesForEveryUserID();
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("add service exception  >>>   $e");
    }
  }

  fillDate(Service a) async{
    name.text = a.name ?? "";
    description.text = a.description ?? "";
    price.text = a.price.toString();
    number_of_employees.text = a.number_of_employees.toString();
    fromTime.onUpdateData(a.availability?.split(" - ").first);
    selectedCategory.onUpdateData(a.category);
    toTime.onUpdateData(a.availability?.split(" - ").last);
    duration.text = a.duration ?? "";
    imageUpdateURL = a.imageUrl ?? "";
    imageFile.onUpdateData(await Helper.getImageFileByUrl(a.imageUrl ?? ""));
  }

  clearDate() async{
    name.text = "";
    description.text = "";
    price.text = "";
    number_of_employees.text = "";
    fromTime.onUpdateData(null);
    selectedCategory.onUpdateData(null);
    toTime.onUpdateData(null);
    duration.text = "";
    imageUpdateURL = "";
    imageFile.onUpdateData(null);
  }

  updateService(String serviceId) async{
    if (!formKey.currentState!.validate()){
      return;
    }

    if(selectedCategory.state.data == null){
      UI.showMessage("Please select category");
      return;
    }
    //
    // if(fromTime.state.data == null){
    //   UI.showMessage("Please select from time");
    //   return;
    // }
    //
    // if(toTime.state.data == null){
    //   UI.showMessage("Please select to time");
    //   return;
    // }

    if(imageFile.state.data == null){
      UI.showMessage("Upload Service image");
      return;
    }
    Service serv = Service();

    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      String urlProductImage = await firebaseHelper.updateImage(
          imageFile.state.data ?? File(""),
        imageUpdateURL
      );

      serv.serviceId = serviceId;
      serv.name = name.text;
      serv.description = description.text;
      serv.price = double.parse(price.text);
      serv.number_of_employees = int.parse(number_of_employees.text);
      serv.salonId = PrefManager.currentUser?.id;
      serv.availability = "${fromTime.state.data} - ${toTime.state.data}";
      serv.category = selectedCategory.state.data;
      serv.duration = duration.text;
      serv.imageUrl = urlProductImage;

      await firebaseHelper.updateDocument(CollectionNames.servicesTable, serviceId, serv.toMap());
      UI.showMessage("Service updated success");
      loading.onUpdateData(false);
      getAllServicesForEveryUserID();
      UI.pop();
    }catch (e){
      loading.onUpdateData(false);
      print("update service exception  >>>   $e");
    }
  }


 deleteService(String serviceId) async{
    try {
      loading.onLoadingState();
      loading.onUpdateData(true);
      await firebaseHelper.deleteDocument(CollectionNames.servicesTable, serviceId);
      UI.showMessage("Service deleted success");
      if(PrefManager.currentUser?.type == 1){
        UI.pop();
      }
      getAllServicesForEveryUserID();
      loading.onUpdateData(false);
    }catch (e){
      loading.onUpdateData(false);
      print("delete service exception  >>>   $e");
    }
  }



  getAllServicesForEveryUserID() async{
    try {
      services.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.servicesTable, "salonId", PrefManager.currentUser!.id);
      List<Service> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Service.fromMap(res.data() as Map<String, dynamic>));
      });
      services.onUpdateData(servs);
    }catch (e){
      services.onUpdateData([]);
      print("getAllServicesForEveryUserID exception  >>>   $e");
    }
  }


 getServicesByUserID(String id) async{
    try {
      services.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.servicesTable, "salonId", id);
      List<Service> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Service.fromMap(res.data() as Map<String, dynamic>));
      });
      services.onUpdateData(servs);
    }catch (e){
      services.onUpdateData([]);
      print("getServicesByUserID exception  >>>   $e");
    }
  }


  getServicesByCategory(String category) async{
    try {
      services.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.servicesTable, "category", category);
      List<Service> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Service.fromMap(res.data() as Map<String, dynamic>));
      });
      services.onUpdateData(servs);
    }catch (e){
      services.onUpdateData([]);
      print("getServicesByCategory exception  >>>   $e");
    }
  }

  getServicesByCategoryAndSalonId(String category, String salonId) async{
    try {
      services.onLoadingState();
      // List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocuments(CollectionNames.servicesTable, "category", category);
      List<QueryDocumentSnapshot> results = await firebaseHelper.searchDocumentsWithOptions(CollectionNames.servicesTable, {"category": category, "salonId": salonId});
      List<Service> servs = [];
      results.forEach((res){
        print(res.data());
        servs.add(Service.fromMap(res.data() as Map<String, dynamic>));
      });
      services.onUpdateData(servs);
    }catch (e){
      services.onUpdateData([]);
      print("getServicesByCategory exception  >>>   $e");
    }
  }

  getAllServices() async{
    try {
      allservices.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.servicesTable);
      List<Service> servs = [];
      results.forEach((res){
        print( res.data());
        servs.add(Service.fromMap(res.data() as Map<String, dynamic>));
      });
      allservices.onUpdateData(servs);
    }catch (e){
      allservices.onUpdateData([]);
      print("getServicesByCategory exception  >>>   $e");
    }
  }
}