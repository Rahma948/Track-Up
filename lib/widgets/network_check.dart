import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_manger/config/constant.dart';

class NetworkCheck extends StatelessWidget {
  final Widget child;

  const NetworkCheck({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged.map(
        (results) =>
            results.isNotEmpty ? results.first : ConnectivityResult.none,
      ),

      builder: (context, snapshot) {
        final connected = snapshot.data != ConnectivityResult.none;

        return Stack(
          children: [
            child,

            if (!connected)
              Container(
                color: kPrimaryColor.withOpacity(.9),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.wifi_off, size: 40, color: Colors.white),
                    SizedBox(height: 15),
                    Text(
                      "No Data Connection",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
