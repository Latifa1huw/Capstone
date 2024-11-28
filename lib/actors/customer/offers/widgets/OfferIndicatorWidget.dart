import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/constants/colors.dart';

class OfferIndicatorWidget extends StatefulWidget {
  final int offerImages;
  final int currentIndex; // This should be passed in when the index changes

  OfferIndicatorWidget({Key? key, required this.offerImages, required this.currentIndex}) : super(key: key);

  @override
  _OfferIndicatorWidgetState createState() => _OfferIndicatorWidgetState();
}

class _OfferIndicatorWidgetState extends State<OfferIndicatorWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(widget.currentIndex);
    });
  }

  @override
  void didUpdateWidget(covariant OfferIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _scrollToIndex(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Method to scroll to the current index
  void _scrollToIndex(int index) {
    double itemWidth = 10.sp + 10; // Item width + separator (10 here)
    _scrollController.animateTo(
      itemWidth * index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 15.sp,
        width: 55.sp,
        child: ListView.separated(
          controller: _scrollController, // Add scroll controller here
          itemCount: widget.offerImages,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Material(
              elevation: 1,
              shadowColor: AppColors.kButtonColor,
              color: AppColors.kMainColor,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(90),
                borderSide: BorderSide.none
              ),
              child: Container(
                height: 10.sp,
                width: 10.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kMainColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kButtonColor,
                      spreadRadius: 1,
                      blurRadius: 1
                    ),
                    BoxShadow(
                      color: AppColors.kButtonColor,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: widget.currentIndex == index?  [
                      AppColors.kButtonColor,
                      AppColors.kButtonColor,
                      AppColors.kButtonColor,
                    ]: [
                      AppColors.kMainColor,
                      AppColors.kMainColor,
                      AppColors.kMainColor,
                    ]
                  )
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 10,
            );
          },
        ),
      ),
    );
  }
}
