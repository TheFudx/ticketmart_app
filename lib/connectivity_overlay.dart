import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_cubit.dart';

class ConnectivityOverlay extends StatelessWidget {
  const ConnectivityOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        return isConnected
            ? const SizedBox.shrink()
            : Positioned.fill(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/no_internet.png'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Handle retry logic here if needed
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
