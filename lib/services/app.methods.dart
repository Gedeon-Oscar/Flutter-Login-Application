import 'package:flutter/material.dart';
import 'package:locallancers/utils/app.colors.dart';

class AppMethods {

  static void showErrorDialog({required String error, required BuildContext ctx})
  {
    showDialog(
        context: ctx,
        builder: (context)
        {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.00),
                  child: Icon(
                    size: 35.00,
                    Icons.error,
                    color: AppColors.accentErrorColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.00),
                  child: Text(
                    'Error Message!!',
                    style: TextStyle(
                      fontFamily: 'Open_Sans',
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBgColor,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: ()
                  {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        'OK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBgColor,
                      ),
                    ),
                  ),
              ),
            ],
          );
        }
    );
  }

}