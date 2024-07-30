

package com.alphastudioz.ticketmart

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.razorpay.RazorpayPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register the Razorpay plugin
        flutterEngine.plugins.add(RazorpayPlugin())
    }
}