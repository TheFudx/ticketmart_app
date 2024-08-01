package com.alphastudioz.ticketmart

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.razorpay.Checkout
import com.razorpay.PaymentResultListener

class MainActivity : FlutterActivity(), PaymentResultListener {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        // Initialize Razorpay
        Checkout.preload(applicationContext)
    }

    // Implement the PaymentResultListener methods
    override fun onPaymentSuccess(razorpayPaymentID: String?) {
        // Handle payment success
        println("Payment Success: $razorpayPaymentID")
    }

    override fun onPaymentError(code: Int, description: String?) {
        // Handle payment error
        println("Payment Error: Code $code, Description $description")
    }
}
