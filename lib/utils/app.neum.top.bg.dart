import 'package:flutter/material.dart';
import '../utils/app.colors.dart';
import 'package:clay_containers/clay_containers.dart';

class NeumorphismTopBg extends StatelessWidget {
  const NeumorphismTopBg({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          color: AppColors.whiteColor,
          height: size.height * 0.4,
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: -size.height * 0.01,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClayContainer(
                      color: AppColors.whiteColor,
                      width: 220.0,
                      height: 220.0,
                      borderRadius: 200.0,
                      depth: -50,
                      curveType: CurveType.convex,
                    ),
                    ClayContainer(
                      color: AppColors.whiteColor,
                      width: 180.0,
                      height: 180.0,
                      borderRadius: 200.0,
                      depth: 50,
                      curveType: CurveType.convex,
                    ),
                    ClayContainer(
                      color: AppColors.whiteColor,
                      width: 140.0,
                      height: 140.0,
                      borderRadius: 200.0,
                      depth: -50,
                      curveType: CurveType.convex,
                    ),
                    ClayContainer(
                      color: AppColors.whiteColor,
                      width: 100.0,
                      height: 100.0,
                      borderRadius: 200.0,
                      depth: 50,
                      curveType: CurveType.convex,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}