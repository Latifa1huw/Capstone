import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/constants/collection_names.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/models/failure.dart';
import 'package:template/shared/network/firebase_helper.dart';
import 'package:template/shared/util/ui.dart';

class ListUsersViewModel{
  FirebaseHelper firebaseHelper = FirebaseHelper();
  GenericCubit<bool> loading = GenericCubit(false);
  GenericCubit<List<User>> users = GenericCubit([]);
  GenericCubit<String> status = GenericCubit("Unblocked");

  getAllUsers() async{
    try {
      users.onLoadingState();
      List<QueryDocumentSnapshot> results = await firebaseHelper.getAllDocuments(CollectionNames.usersTable);
      List<User> ords = [];

      results.forEach((res){
        Logger().d(res.data());
        ords.add(User.fromJson(res.data() as Map<String, dynamic>));
      });
      users.onUpdateData(ords);
    }catch (e){
      users.onUpdateData([]);
      print("get orders exception  >>>   $e");
    }
  }

  blockSalon(User user) async{
    try{
      loading.onUpdateData(true);
      user.status = status.state.data;
      print("user.get() >>>>  ${user.toMapSalon()}");

      await firebaseHelper.updateDocument(CollectionNames.usersTable, user.id ?? "", user.toMapSalon());
      loading.onUpdateData(false);
      UI.showMessage("Salon is ${user.status}");
      getAllUsers();
    } on Failure catch (e) {
      loading.onUpdateData(false);
      loading.onErrorState(e);
    }
  }

}