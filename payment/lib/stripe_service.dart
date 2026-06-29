import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:payment/payment_failed.dart';
import 'package:payment/payment_success.dart';

class StripeService {
  static Future<void> makePayment(BuildContext context, String amount) async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.29.245:8080/stripe_api/create_payment_intent.php",
        ),
        body: {"amount": amount},
      );

      final data = jsonDecode(response.body);

      if (data["error"] != null) {
        throw Exception(data["error"]);
      }

      String clientSecret = data["clientSecret"];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: "My Store",
          paymentIntentClientSecret: clientSecret,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              amount: amount,
              transactionId: data["paymentIntentId"] ?? "",
            ),
          ),
        );
      }
    } on StripeException {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentFailedScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
