import 'dart:async';

import 'package:assignments/constants/puchase_const.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseButton extends StatefulWidget {
  const InAppPurchaseButton({Key? key}) : super(key: key);

  @override
  _InAppPurchaseButtonState createState() => _InAppPurchaseButtonState();
}

class _InAppPurchaseButtonState extends State<InAppPurchaseButton> {
  final _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      await _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      // Send to server
      var validPurchase = await _verifyPurchase(purchaseDetails);
      print('Purchase Validation $validPurchase');
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
    _subscription.cancel();
  }

  void _updateStreamOnError(dynamic error) {
    // ignore: avoid_print
    print(error);
  }

  _pay() async {
    final bool available = await _iap.isAvailable();
    print(available);
    if (available) {
      const Set<String> _kIds = <String>{storeKeyConsumable};
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_kIds);
      print(response.productDetails[0].description);
      final productDetails = response.productDetails[0];
      PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _pay,
      child: Text(
        'Buy Premium',
      ),
    );
  }
}
