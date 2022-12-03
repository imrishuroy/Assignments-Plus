// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// final String testID = 'gems_test';

// class MarketScreen extends StatefulWidget {
//   createState() => MarketScreenState();
// }

// class MarketScreenState extends State<MarketScreen> {
//   /// Is the API available on the device
//   bool _available = true;

//   /// The In App Purchase plugin
//   // InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

//   InAppPurchase _iap = InAppPurchase.instance;

//   /// Products for sale
//   List<ProductDetails> _products = [];

//   /// Past purchases
//   List<PurchaseDetails> _purchases = [];

//   /// Updates to purchases
//   late StreamSubscription _subscription;

//   /// Consumable credits the user can buy
//   int _credits = 0;

//   @override
//   void initState() {
//     _initialize();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   /// Initialize data 
//   void _initialize() async {

//     // Check availability of In App Purchases
//     _available = await _iap.isAvailable();

//     if (_available) {

//       await _getProducts();
//      // await _getPastPurchases();

//       // Verify and deliver a purchase with your own business logic
//       _verifyPurchase();

//     }
//   }

//    /// Get all products available for sale
//   Future<void> _getProducts() async {
//     Set<String> ids = Set.from([testID, 'test_a']);
//     ProductDetailsResponse response = await _iap.queryProductDetails(ids);

//     setState(() { 
//       _products = response.productDetails;
//     });
//   }

//     /// Gets past purchases
//   // Future<void> _getPastPurchases() async {

//   //  await _iap.
//   //   QueryPurchaseDetailsResponse response =
//   //       await _iap.queryPastPurchases();

//   //   for (PurchaseDetails purchase in response.pastPurchases) {
//   //     final pending = Platform.isIOS
//   //       ? purchaseDetails.pendingCompletePurchase
//   //       : !purchaseDetails.billingClientPurchase.isAcknowledged;

//   //       if (pending) {
//   //         InAppPurchaseConnection.instance.completePurchase(purchase);
//   //       }
//   //   }

//   //   setState(() {
//   //     _purchases = response.pastPurchases;
//   //   });
//   // }

//    /// Returns purchase of specific product ID
//   PurchaseDetails _hasPurchased(String productID) {
//     return _purchases.firstWhere( (purchase) => purchase.productID == productID, orElse: () => null);
//   }

//   /// Your own business logic to setup a consumable
//   void _verifyPurchase() {
//     PurchaseDetails purchase = _hasPurchased(testID);

//     // TODO serverside verification & record consumable in the database

//     if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//       _credits = 10;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_available ? 'Open for Business' : 'Not Available'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             for (var prod in _products)

//               // UI if already purchased
//               if (_hasPurchased(prod.id) != null)
//                 ...[]

//               // UI if NOT purchased
//               else
//                 ...[]
//           ],
//         ),
//       ),
//     );
//   }

//   // Private methods go here

// }
