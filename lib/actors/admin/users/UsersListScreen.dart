import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/features/admin/users/list_users_viewModel.dart';
import 'package:template/features/admin/users/user_details_page.dart';
import 'package:template/features/authentication/models/user.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/constants/colors.dart';
import 'package:template/shared/constants/styles.dart';
import 'package:template/shared/extentions/padding_extentions.dart';
import 'package:template/shared/generic_cubit/generic_cubit.dart';
import 'package:template/shared/resources.dart';
import 'package:template/shared/ui/componants/empty_page.dart';
import 'package:template/shared/ui/componants/loading_widget.dart';
import 'package:template/shared/widgets/CustomAppBarNotAuth.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  ListUsersViewModel viewModel = ListUsersViewModel();

  bool isCustomersTab = false;
  @override
  void initState() {
    viewModel.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarWithoutBack(context, title: "All Users", isBack: false),
      body: Column(
        children: [
          // Tab Buttons
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                // Salons Tab - Takes half width
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCustomersTab = false;  // Switch to Salons tab
                    });
                  },
                  child: Container(
                    height: 40.sp,
                    decoration: BoxDecoration(
                      //   color: isCustomersTab ? AppColors.kBlackColor.withOpacity(.2) : AppColors.kMainColor,  // Highlight based on selection
                      //   borderRadius: const BorderRadius.only(
                      //   topRight: Radius.circular(10),
                      //   bottomRight: Radius.circular(10),
                      // )
                        border: Border(
                            bottom: !isCustomersTab ? BorderSide(color: AppColors.kBlackColor, width: 2): BorderSide.none
                        )
                    ),
                    alignment: Alignment.center,  // Center the text
                    child: Text(
                      'Service Provider',
                      style: AppStyles.kTextStyleHeader20.copyWith(
                          color: AppColors.kButtonColor
                      ),
                    ),
                  ),
                ),

                AppSize.h30.pw,

                // Customers Tab - Takes half width
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCustomersTab = true;  // Switch to Customers tab
                    });
                  },
                  child: Container(
                    height: 40.sp,
                    decoration: BoxDecoration(
                      // color: isCustomersTab ? AppColors.kMainColor : AppColors.kBlackColor.withOpacity(.2),  // Highlight based on selection
                      // borderRadius: const BorderRadius.only(
                      //   topLeft: Radius.circular(10),
                      //   bottomLeft: Radius.circular(10),
                      // ),
                        border: Border(
                            bottom: isCustomersTab ? BorderSide(color: AppColors.kBlackColor, width: 2): BorderSide.none
                        )
                    ),
                    alignment: Alignment.center,  // Center the text
                    child: Text(
                      'Customers',
                      style: AppStyles.kTextStyleHeader20.copyWith(
                          color: AppColors.kButtonColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<GenericCubit<List<User>>,
              GenericCubitState<List<User>>>(
              bloc: viewModel.users,
              builder: (context, state) {
                List<User> customers = [];
                List<User> salons = [];
                state.data.forEach((e){
                  if(e.type == 2){
                    customers.add(e);
                  }
                  if(e.type == 3){
                    salons.add(e);
                  }
                });
                return state is GenericLoadingState ? const Loading()
                    : state.data.isEmpty ? EmptyData() :
                Expanded(
                  child: ListView.builder(
                  itemCount: isCustomersTab ? customers.length : salons.length,
                  itemBuilder: (context, index) {
                    return UserCard(user: isCustomersTab ? customers[index] : salons[index], viewModel: viewModel,);
                    },
                  ),
                );
            }
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;
  final ListUsersViewModel viewModel;
  UserCard({required this.user, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // Determine if the user is a customer or salon
    bool isCustomer = user.type == 2;
    bool isSalon = user.type == 3;

    if(user.type == 1){
      return SizedBox();
    }

    return Card(
      margin: EdgeInsets.all(10),
      color: user.status == "Blocked" && user.type == 3? AppColors.kRedColor.withOpacity(.1): AppColors.kWhiteColor,
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.profile_image ?? ''),
        ),
        title: Row(
          children: [
            Text(user.name ?? 'No Name', style: AppStyles.kTextStyleHeader20,),
            AppSize.h10.pw,
            user.type == 2 ?
            Image.asset(Resources.user, height: 15.sp, ):
            Image.asset(Resources.salon, height: 15.sp,)
          ],
        ),
        subtitle: isCustomer
            ? const Text('Customer')
            : isSalon
            ? Text('Salon Owner: ${user.owner_name ?? ''}')
            : const Text(''),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_){
                return UserDetailsPage(profile: user, viewModel: viewModel,);
              })
            );
          },
        ),
      ),
    );
  }
}