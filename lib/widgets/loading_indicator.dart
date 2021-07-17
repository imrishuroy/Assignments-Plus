import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  const LoadingIndicator({Key? key, this.size = 50.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const SpinKitCircle(
          color: Colors.green,
        ),
      ),
    );
  }
  //   return SpinKitFadingCircle(
  //     itemBuilder: (BuildContext context, int index) {
  //       return DecoratedBox(
  //         decoration: BoxDecoration(color: Colors.blue),
  //       );
  //     },
  //   );
  // }
}
