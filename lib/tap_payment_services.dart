import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:tap_payment_test/config_reader.dart';

class TapPayService {
  static configureAppTapPayment() {
    GoSellSdkFlutter.configureApp(
        bundleId: Platform.isAndroid
            ? "com.sa.bootfi.cardetails.android"
            : "com.sa.bootfi.cardetails.ios",
        productionSecreteKey: "",
        sandBoxsecretKey: Platform.isAndroid
            ? ConfigReader.tapAndroidTestKey
            : ConfigReader.tapIOSTestKey,
        lang: "en");
  }

  static Future<void> setupSDKSession() async {
    debugPrint("setupSDKSession");
    try {
      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.PURCHASE,

        transactionCurrency: "SAR",
        amount: "98.9",
        customer: Customer(
          customerId: "cus_TS060520221355x7HY1602866",
          email: "jony@yomail.com",
          firstName: "رغدة المواجدة",
          isdNumber: '',
          lastName: "رغدة المواجدة",
          middleName: "رغدة المواجدة",
          number: "554766833",
        ),
        paymentItems: <PaymentItem>[
          PaymentItem(
              name: "Alice did not like to see.",
              amountPerUnit: 86,
              quantity: Quantity(value: 1),
              discount: null,
              description:
                  "Next came an angry tone, 'Why, Mary Ann, and be turned out of the day; and this time the Queen was.",
              taxes: [
                Tax(
                    amount: Amount(
                        type: "official",
                        value: 12.9,
                        minimumFee: 0,
                        maximumFee: 0),
                    name: "Value Added Tax",
                    description: "Value Added Tax")
              ],
              totalAmount: 100),
        ],
        postURL: "https://testig.cardetails.store//v1/tap-response",
        paymentDescription: "pay for 2202000050 order",
        // Payment Reference
        paymentReference: Reference(
          acquirer: "acquirer",
          gateway: "gateway",
          payment: "payment",
          track: "track",
          transaction: "trans_91010122",
          order: "c6e4bd90-8f16-11ec-adeb-519e6a5fbca9",
        ),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: true,
        // Receipt SMS/Email
        receipt: Receipt(false, false),
        // receipt: Receipt(false, false),
        // Authorize Action [Capture - Void]
        authorizeAction: AuthorizeAction(
          type: AuthorizeActionType.CAPTURE,
          timeInHours: 10,
        ),
        merchantID: "",

        // Allowed cards
        // allowedCadTypes: CardType.CREDIT,
        allowsToSaveSameCardMoreThanOnce: false,
        // pass the card holder name to the SDK
        cardHolderName: "",
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        paymentType: PaymentType.CARD,
        sdkMode: SDKMode.Sandbox,

        allowedCadTypes: CardType.ALL,
        // Payment Metadata
        paymentMetaData: {"udf1": "c6e4bd90-8f16-11ec-adeb-519e6a5fbca9"},
        shippings: [],
        taxes: [
          Tax(
              amount: Amount(
                  type: "official", value: 12.9, minimumFee: 0, maximumFee: 0),
              name: "Value Added Tax",
              description: "Value Added Tax")
        ],
      );
    } catch (e) {
      debugPrint(e.toString() + " error pay");
    }
  }

  static Future<void> pay() async {
    var tapSDKResult;
    try {
      await configureAppTapPayment();
      await setupSDKSession();
      tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
    } catch (exception, _) {
      debugPrint(exception.toString() + " error sdk");
    }
    debugPrint("pay tapSDKResult " + tapSDKResult.toString());

    if (tapSDKResult != null) {
      switch (tapSDKResult['sdk_result']) {
        case "SUCCESS":
          print(PaymentResultTypes.sucess.name);

          break;
        case "FAILED":
          print(PaymentResultTypes.faild.name);
          // Helpers.handleSDKResult(tapSDKResult);
          break;
        case "CANCELLED":
          print(PaymentResultTypes.cancelled.name);

          // Helpers.handleSDKResult(tapSDKResult);
          break;
        case "SDK_ERROR":
          print(PaymentResultTypes.sdkError);
          debugPrint('sdk error............');
          debugPrint('${tapSDKResult['sdk_error_code']}');
          debugPrint(tapSDKResult['sdk_error_message']);
          debugPrint(tapSDKResult['sdk_error_description']);
          debugPrint('sdk error............');
          break;

        case "NOT_IMPLEMENTED":
          print(PaymentResultTypes.notImplemented.name);
          break;
      }
    }
  }
}

enum PaymentResultTypes {
  sucess,
  faild,
  sdkError,
  cancelled,
  notImplemented,
  notAuth,
}
