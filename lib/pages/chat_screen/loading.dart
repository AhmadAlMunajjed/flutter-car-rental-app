import 'package:car_rental_app_ui/constants/color_constants.dart';
import 'package:flutter/material.dart';



class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.themeColor),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
