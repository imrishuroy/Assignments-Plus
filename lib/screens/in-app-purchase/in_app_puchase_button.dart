import 'dart:async';
import 'dart:io';

import 'package:assignments/constants/puchase_const.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
//import for AppStorePurchaseDetails
// import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
//import for SKProductWrapper

class InAppPurchaseButton extends StatefulWidget {
  const InAppPurchaseButton({Key? key}) : super(key: key);

  @override
  _InAppPurchaseButtonState createState() => _InAppPurchaseButtonState();
}

class _InAppPurchaseButtonState extends State<InAppPurchaseButton> {
  final _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void initState() {
    super.initState();
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
      //  cancelOnError: true,
    );
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    print('Purchase Details Status ${purchaseDetails.status}');
    try {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Send to server
        var validPurchase = await _verifyPurchase(purchaseDetails);
        print('Payment Result $validPurchase');
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
      if (purchaseDetails.status == PurchaseStatus.error) {
        print('Error purchase details ${purchaseDetails.error?.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${purchaseDetails.error?.message}',
            ),
          ),
        );
      }
    } catch (error) {
      print('Handle Purchase error ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    //await Firebase.initializeApp();
    var functions = FirebaseFunctions.instanceFor(region: cloudRegion);
    final callable = functions.httpsCallable('verifyPurchase');
    final results = await callable({
      'source': purchaseDetails.verificationData.source,
      'verificationData':
          purchaseDetails.verificationData.serverVerificationData,
      'productId': purchaseDetails.productID,
    });
    return results.data as bool;
  }

  void _updateStreamOnDone() {
    _subscription?.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    // ignore: avoid_print
    print(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error.toString(),
        ),
      ),
    );
  }

  Future<void> _pay() async {
    try {
      final bool available = await _iap.isAvailable();
      print(available);
      if (available) {
        // Workaround to mark as finished failed transactions on iOS
        if (Platform.isIOS) {
          final queueWrapper = SKPaymentQueueWrapper();
          final transactions = await queueWrapper.transactions();
          final failedTransactions = transactions.where((t) =>
              t.transactionState == SKPaymentTransactionStateWrapper.failed);

          final result = await Future.wait(
              failedTransactions.map((t) => queueWrapper.finishTransaction(t)));
          print('Payment Cancelation result $result');
        }

        const Set<String> _kIds = <String>{storeKeyConsumable};
        print('KIDS $_kIds');
        final ProductDetailsResponse response =
            await InAppPurchase.instance.queryProductDetails(_kIds);
        print('Response ${response.productDetails}');
        print(response.productDetails[0].description);
        final productDetails = response.productDetails[0];
        print('Product Details $productDetails');

        PurchaseParam purchaseParam = PurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
        );
        print('Purchase Params $purchaseParam');
        final result = await _iap.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true,
        );
        print('Payment Result $result');
      }
    } catch (error) {
      print('Payment Error ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _pay,
      child: Text(
        'Buy Premium',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
