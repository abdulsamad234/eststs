import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estats/common/helper.dart';
import 'package:estats/components/custom_text_box.dart';
import 'package:estats/components/home_cell.dart';
import 'package:estats/components/primary_button.dart';
import 'package:estats/components/secondary_button.dart';
import 'package:estats/pages/coach/basketball/stats/components/stats_history_cell.dart';
import 'package:estats/pages/coach/basketball_home.dart';
import 'package:estats/pages/coach/coach_home.dart';
import 'package:estats/pages/coach/football_home.dart';
import 'package:estats/pages/coach/profile/profile_page.dart';
import 'package:estats/pages/fan/basketball_stats_page_live.dart';
import 'package:estats/pages/fan/components/live_game_cell.dart';
import 'package:estats/pages/fan/fan_stats_history_page.dart';
import 'package:estats/pages/fan/fan_stats_history_search.dart';
import 'package:estats/pages/fan/stats_page_live.dart';
import 'package:estats/services/PaypalPayment.dart';
import 'package:estats/services/dataservice.dart';
import 'package:estats/styleguide/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File currentSelectedImage;
  int currentSelectedTab = 0;
  bool isLoading = false;
  List<Map<String, dynamic>> currentGamesFan = List<Map<String, dynamic>>();
  DateFormat df = DateFormat('MMMM d, y');
  List<DropdownMenuItem<dynamic>> schoolItems =
      List<DropdownMenuItem<dynamic>>();
  String currentSelectedSchool = '';
  List<String> schoolItemsString = List<String>();
  List<String> _kProductIds = <String>['coach_sub'];

  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        verifiedPurchases.add(purchase);
      }
    }
    // List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      // _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.

    return Future<bool>.value(purchaseDetails.error == null);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print('purchase id: ${purchaseDetails.productID}');
      if (purchaseDetails.productID == 'coach_sub') {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          // showPendingUI();
          setState(() {
            _purchasePending = true;
          });
        } else {
          setState(() {
            _purchasePending = false;
          });
          if (purchaseDetails.status == PurchaseStatus.error) {
            // handleError(purchaseDetails.error);
          } else if (purchaseDetails.status == PurchaseStatus.purchased) {
            bool valid = await _verifyPurchase(purchaseDetails);
            if (valid) {
              // deliverProduct(purchaseDetails);
              await InAppPurchaseConnection.instance
                .completePurchase(purchaseDetails);
//  InAppPurchaseConnection.instance
//                 .consumePurchase(purchaseDetails);
              FirebaseAuth.instance.currentUser().then((value) {
                Firestore.instance
                    .collection('users')
                    .document(value.uid)
                    .updateData({'paid': true});
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CoachHomePage()));
              });
            } else {
              _handleInvalidPurchase(purchaseDetails);
              return;
            }
          }
          // if (Platform.isAndroid) {
          //   // if (!kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            // await InAppPurchaseConnection.instance
            //     .consumePurchase(purchaseDetails);
          //   // }
          // }
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchaseConnection.instance
                .completePurchase(purchaseDetails);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainBGColor,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Please subscribe to Estats premium membership to use this app',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                PrimaryButton(
                  onPressed: (context) async {
                    print('Paying for coach');
                    PurchaseParam purchaseParam = PurchaseParam(
                        productDetails: _products[0],
                        applicationUserName: null,
                        sandboxTesting: false);
                    print('${_products[0].id}');
                    if (_products[0].id == 'coach_sub') {
                      bool bought = await _connection.buyConsumable(
                          purchaseParam: purchaseParam);
                    }
                  },
                  child: Text(
                    'Pay with Apple Pay',
                    style: TextStyle(
                        color: mainBGColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          _purchasePending
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: mainBGColor,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
