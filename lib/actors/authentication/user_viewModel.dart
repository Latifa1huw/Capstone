import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/constants/constants.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/models/failure.dart';
import 'package:template/shared/models/user_model.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/util/app_routes.dart';
import 'package:template/shared/util/ui.dart';
import 'package:uuid/uuid.dart';

class UserViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<User> userCubit = GenericCubit(User());
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<File?> profile_image = GenericCubit(null);
  String profile_image_url = "";
  GenericCubit<String?> fromTime = GenericCubit(null);
  GenericCubit<String?> toTime = GenericCubit(null);

  List<String> timeSlots = [
    '01:00 AM',
    '02:00 AM',
    '03:00 AM',
    '04:00 AM',
    '05:00 AM',
    '06:00 AM',
    '07:00 AM',
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '09:00 PM',
    '10:00 PM',
    '11:00 PM',
    '12:00 PM'
  ];

  // login for both
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController(text: "");
  // TextEditingController email = TextEditingController(text: "lara@gmail.com");
  TextEditingController email = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");
  TextEditingController address = TextEditingController(text: "");
  // TextEditingController password = TextEditingController(text: "123456");
  TextEditingController password = TextEditingController(text: "");
  TextEditingController confirm_password = TextEditingController(text: "");
  TextEditingController currentPassword = TextEditingController(text: "");
  TextEditingController newPassword = TextEditingController(text: "");
  TextEditingController newPasswordConfirmation = TextEditingController(text: "");
  TextEditingController owner_name = TextEditingController(text: "");
  GenericCubit<String> status = GenericCubit("Unblocked");
  GenericCubit<String> account_type = GenericCubit("Salon");

  // Function to pick an image from the device
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profile_image.onUpdateData(File(pickedFile.path));
    }
  }

  login() async{
    if (!formKey.currentState!.validate()){
      return;
    }
    userCubit.onLoadingState();
    try{
      User user = User();
      user.email = email.text;
      user.password = password.text;
      print("user.get() >>>>  ${user.toMapLogin()}");
      loading.onUpdateData(true);
      List<QueryDocumentSnapshot> result = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "email", email.text);
      if (result.isNotEmpty) {
        var userData = result.first.data() as Map<String, dynamic>;
        if (userData['password'] == password.text) {
          // Successful login
          PrefManager.setCurrentUser(UserModel.fromJson(userData));
          UI.showMessage('Welcome MR or MS: ${userData['name']}');
          if(PrefManager.currentUser?.type == 1){
            UI.pushWithRemove(AppRoutes.adminStartPage);
          }else if(PrefManager.currentUser?.type == 2){
            UI.pushWithRemove(AppRoutes.customerStartPage);
          } else if(PrefManager.currentUser?.type == 3){
            UI.pushWithRemove(AppRoutes.salonStartPage);
          }
        } else {
          // Password incorrect
          UI.showMessage('Invalid password');
        }
        loading.onUpdateData(false);
      } else {
        loading.onUpdateData(false);
        // Email not found
        UI.showMessage('No user found with that email');
      }
      print("login.get() >>>> ");
      print(result.asMap());
    } on Failure catch (e) {
      loading.onUpdateData(false);
      userCubit.onErrorState(e);
    }
  }

  customerRegister() async{
    if (!formKey.currentState!.validate()){
      return;
    }

    // if(profile_image.state.data == null){
    //   UI.showMessage("Upload Profile image");
    //   return;
    // }

    userCubit.onLoadingState();
    try{
      String userId = Uuid().v4(); // Generate a unique ID for the user
      loading.onUpdateData(true);

      String urlProfileImage = profile_image.state.data == null?
      AppConstants.defualtImage :
      await firebaseHelper.uploadImage(
          profile_image.state.data ?? File(""));

      User user = User();
      user.id = userId;
      user.name = name.text;
      user.email = email.text;
      user.password = password.text;
      user.address = address.text;
      user.phone = phone.text;
      user.profile_image = urlProfileImage;
      user.type = 2;
      print("user.get() >>>>  ${user.toMap()}");
      loading.onUpdateData(true);
      bool emailUnique = await isEmailUnique(email.text);
      if (!emailUnique) {
        UI.showMessage('Email already exists. Please use a different email.');
        loading.onUpdateData(false);
        return;
      }

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.usersTable, userId, user.toMap());

      List<QueryDocumentSnapshot> result = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "email", email.text);
      if(result.isNotEmpty){
        var userData = result.first.data() as Map<String, dynamic>;
        PrefManager.setCurrentUser(UserModel.fromJson(userData));
        UI.showMessage('register success');
        UI.pushWithRemove(AppRoutes.customerStartPage);
      } else{
        UI.showMessage('register failed');
      }
      loading.onUpdateData(false);
      print("documentReference.get() >>>> ");
      print(querySnapshot?.docs.asMap());
    } on Failure catch (e) {
      loading.onUpdateData(false);
      userCubit.onErrorState(e);
    }
  }

  adminRegister() async{
    if (!formKey.currentState!.validate()){
      return;
    }

    userCubit.onLoadingState();
    try{
      String userId = Uuid().v4(); // Generate a unique ID for the user

      User user = User();
      user.id = userId;
      user.name = name.text;
      user.email = email.text;
      user.password = password.text;
      user.address = address.text;
      user.phone = phone.text;
      user.type = 1;
      print("user.get() >>>>  ${user.toMapAdmin()}");

      loading.onUpdateData(true);
      bool emailUnique = await isEmailUnique(email.text);
      if (!emailUnique) {
        UI.showMessage('Email already exists. Please use a different email.');
        loading.onUpdateData(false);
        return;
      }

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.usersTable, userId, user.toMapAdmin());

      List<QueryDocumentSnapshot> result = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "email", email.text);
      if(result.isNotEmpty){
        var userData = result.first.data() as Map<String, dynamic>;
        PrefManager.setCurrentUser(UserModel.fromJson(userData));
        UI.showMessage('register success');
        UI.pushWithRemove(AppRoutes.adminStartPage);
      } else{
        UI.showMessage('register failed');
      }
      loading.onUpdateData(false);
      print("documentReference.get() >>>> ");
      print(querySnapshot?.docs.asMap());
    } on Failure catch (e) {
      loading.onUpdateData(false);
      userCubit.onErrorState(e);
    }
  }

  salonRegister() async{
    if (!formKey.currentState!.validate()){
      return;
    }
    // if(profile_image.state.data == null){
    //   UI.showMessage("Upload Profile image");
    //   return;
    // }

    if(fromTime.state.data == null){
      UI.showMessage("Please select from time");
      return;
    }

    if(toTime.state.data == null){
      UI.showMessage("Please select to time");
      return;
    }

    userCubit.onLoadingState();
    try{
      String userId = Uuid().v4(); // Generate a unique ID for the user
      loading.onUpdateData(true);
      String urlProfileImage = profile_image.state.data == null?
      AppConstants.defualtImage : await firebaseHelper.uploadImage(
          profile_image.state.data ?? File(""));

      User user = User();
      user.id = userId;
      user.name = name.text;
      user.email = email.text;
      user.password = password.text;
      user.address = address.text;
      user.phone = phone.text;
      user.profile_image = urlProfileImage;
      user.owner_name = owner_name.text;
      user.status = status.state.data;
      user.fromTime = fromTime.state.data;
      user.toTime = toTime.state.data;
      user.account_type = account_type.state.data;
      user.type = 3;
      print("user.get() >>>>  ${user.toMapSalon()}");

      bool emailUnique = await isEmailUnique(email.text);
      if (!emailUnique) {
        UI.showMessage('Email already exists. Please use a different email.');
        loading.onUpdateData(false);
        return;
      }

      QuerySnapshot? querySnapshot = await firebaseHelper.addDocumentWithSpacificDocID(CollectionNames.usersTable, userId, user.toMapSalon());

      List<QueryDocumentSnapshot> result = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "email", email.text);
      if(result.isNotEmpty){
        var userData = result.first.data() as Map<String, dynamic>;
        PrefManager.setCurrentUser(UserModel.fromJson(userData));
        UI.showMessage('register success');
        UI.pushWithRemove(AppRoutes.salonStartPage);
      } else{
        UI.showMessage('register failed');
      }

      loading.onUpdateData(false);

      print("documentReference.get() >>>> ");
      print(querySnapshot?.docs.asMap());
    } on Failure catch (e) {
      loading.onUpdateData(false);
      userCubit.onErrorState(e);
    }
  }

  Future getUserById() async{
    try{
      userCubit.onLoadingState();
      List<QueryDocumentSnapshot> result = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "id", PrefManager.currentUser!.id);
      userCubit.onUpdateData(User.fromJson(result.first.data() as Map<String, dynamic>));
      PrefManager.setCurrentUser(UserModel.fromJson(result.first.data() as Map<String, dynamic>));
    }catch (e){
      print("get user by id exception $e");
    }
  }

  updatePassword() async{
    try{
      if (!formKey.currentState!.validate()){
        return;
      }
      if(newPassword.text != newPasswordConfirmation.text){
        UI.showMessage("New password should be like new password confirmation");
        return;
      }

      loading.onUpdateData(true);
      List<QueryDocumentSnapshot> result = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "id", PrefManager.currentUser!.id);
      final userResult = User.fromJson(result.first.data() as Map<String, dynamic>);
      if(userResult.password != currentPassword.text){
        UI.showMessage("invalid current password please set it again");
        loading.onUpdateData(false);
      }else{
        userResult.password = newPassword.text;
        if(userResult.type == 1) {
          await firebaseHelper.updateDocument(CollectionNames.usersTable,
              PrefManager.currentUser!.id!, userResult.toMapAdmin());
          loading.onUpdateData(false);
        }
        if(userResult.type == 2) {
          await firebaseHelper.updateDocument(CollectionNames.usersTable,
              PrefManager.currentUser!.id!, userResult.toMap());
          loading.onUpdateData(false);
        }
        if(userResult.type == 3) {
          await firebaseHelper.updateDocument(CollectionNames.usersTable,
              PrefManager.currentUser!.id!, userResult.toMapSalon());
          loading.onUpdateData(false);
        }
        UI.showMessage("Password updated successfully");
        UI.pop();
      }
    }catch (e){
      loading.onUpdateData(false);
      print("get user by id exception $e");
    }
  }

  bool isValidEmail(String email) {
    // Email validation regex pattern
    String pattern =
        r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Function to check if email is unique
  Future<bool> isEmailUnique(String e) async {
    List<QueryDocumentSnapshot> result = await firebaseHelper.searchDocuments(CollectionNames.usersTable, "email", e);
    return result.isEmpty;
  }

  fillAdminData(User u){
    print(u.toMapAdmin());
    name.text = u.name ?? "";
    email.text = u.email ?? "";
    address.text = u.address ?? "";
    password.text = u.password ?? "";
    phone.text = u.phone ?? "";
  }

  fillSalonData(User u) async{
    print(u.toMapSalon());
    name.text = u.name ?? "";
    email.text = u.email ?? "";
    address.text = u.address ?? "";
    phone.text = u.phone ?? "";
    owner_name.text = u.owner_name ?? "";
    password.text = u.password ?? "";
    status.onUpdateData(u.status ?? "");
    account_type.onUpdateData(u.account_type ?? "");
    fromTime.onUpdateData(u.fromTime);
    toTime.onUpdateData(u.toTime);
    profile_image_url = u.profile_image ?? "";
    profile_image.onUpdateData(await getImageFileByUrl(u.profile_image ??  AppConstants.defualtImage));
  }

  fillCustomerData(User u) async{
    print(u.toMap());
    name.text = u.name ?? "";
    email.text = u.email ?? "";
    address.text = u.address ?? "";
    phone.text = u.phone ?? "";
    password.text = u.password ?? "";
    profile_image_url = u.profile_image ?? "";
    profile_image.onUpdateData(await getImageFileByUrl(u.profile_image ?? AppConstants.defualtImage));
  }

  adminUpdateProfile(String userId) async{
    if (!formKey.currentState!.validate()){
      return;
    }
    try{
      User user = User();
      user.id = userId;
      user.name = name.text;
      user.email = email.text;
      user.password = password.text;
      user.address = address.text;
      user.phone = phone.text;
      user.type = 1;
      print("user.get() >>>>  ${user.toMapAdmin()}");

      loading.onUpdateData(true);
      bool emailUnique = await isEmailUnique(email.text);
      if (!emailUnique) {
        await firebaseHelper.updateDocument(CollectionNames.usersTable, userId, user.toMapAdmin());
        await getUserById();
        UI.pushWithRemove(AppRoutes.adminStartPage);
        UI.showMessage("Profile updated Successfully");
      }
      loading.onUpdateData(false);
    } on Failure catch (e) {
      loading.onUpdateData(false);
      loading.onErrorState(e);
    }
  }

  salonUpdateProfile(String userId) async{
    if (!formKey.currentState!.validate()){
      return;
    }
    // if(profile_image.state.data == null){
    //   UI.showMessage("Upload Profile image");
    //   return;
    // }

    if(fromTime.state.data == null){
      UI.showMessage("Please select from time");
      return;
    }

    if(toTime.state.data == null){
      UI.showMessage("Please select to time");
      return;
    }

    userCubit.onLoadingState();
    try{
      loading.onUpdateData(true);

      String urlProfileImage = profile_image.state.data == null?
      AppConstants.defualtImage : await firebaseHelper.updateImage(
          profile_image.state.data ?? File(""),
        profile_image_url
      );

      User user = User();
      user.id = userId;
      user.name = name.text;
      user.email = email.text;
      user.password = password.text;
      user.address = address.text;
      user.phone = phone.text;
      user.profile_image = urlProfileImage;
      user.owner_name = owner_name.text;
      user.status = status.state.data;
      user.fromTime = fromTime.state.data;
      user.toTime = toTime.state.data;
      user.account_type = account_type.state.data;
      user.type = 3;
      print("user.get() >>>>  ${user.toMapSalon()}");

      loading.onUpdateData(true);
      bool emailUnique = await isEmailUnique(email.text);
      if (!emailUnique) {
        await firebaseHelper.updateDocument(CollectionNames.usersTable, userId, user.toMapSalon());
        await getUserById();
        UI.pushWithRemove(AppRoutes.salonStartPage);
        UI.showMessage("Profile updated Successfully");
      }
      loading.onUpdateData(false);
    } on Failure catch (e) {
      loading.onUpdateData(false);
      loading.onErrorState(e);
    }
  }

  customerUpdateProfile(String userId) async{
    if (!formKey.currentState!.validate()){
      return;
    }
    // if(profile_image.state.data == null){
    //   UI.showMessage("Upload Profile image");
    //   return;
    // }

    userCubit.onLoadingState();
    try{

      loading.onUpdateData(true);
      String urlProfileImage = profile_image.state.data == null?
      AppConstants.defualtImage : await firebaseHelper.updateImage(
          profile_image.state.data ?? File(""),
          profile_image_url
      );

      User user = User();
      user.id = userId;
      user.name = name.text;
      user.email = email.text;
      user.password = password.text;
      user.address = address.text;
      user.phone = phone.text;
      user.profile_image = urlProfileImage;
      user.type = 2;
      print("user.get() >>>>  ${user.toMap()}");
      loading.onUpdateData(true);
      bool emailUnique = await isEmailUnique(email.text);
      if (!emailUnique) {
        await firebaseHelper.updateDocument(CollectionNames.usersTable, userId, user.toMap());
        await getUserById();
        UI.pushWithRemove(AppRoutes.customerStartPage);
        UI.showMessage("Profile updated Successfully");
      }
      loading.onUpdateData(false);
    } on Failure catch (e) {
      loading.onUpdateData(false);
      loading.onErrorState(e);
    }
  }

  Future<File?> getImageFileByUrl(String url) async {
    try {
      Dio dio = Dio();

      // Get the file name from the URL
      String fileName = path.basename(url);

      // Get the directory to save the file
      Directory tempDir = await getTemporaryDirectory();
      String filePath = path.join(tempDir.path, fileName);

      // Download the file
      await dio.download(url, filePath);

      // Return the downloaded file
      return File(filePath);
    } catch (e) {
      print("Error downloading file: $e");
      return null;
    }
  }
}