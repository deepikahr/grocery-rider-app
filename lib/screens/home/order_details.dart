import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:grocerydelivery/widgets/normalText.dart';
import '../../styles/styles.dart';

class OrderDetails extends StatefulWidget {
  final String? orderID;
  final Map? localizedValues;
  final String? locale;

  OrderDetails({Key? key, this.localizedValues, this.locale, this.orderID})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map? order;
  String? currency, mobileNumber;
  bool orderDataLoading = false;
  var fullName, deliveryAddress;

  @override
  void initState() {
    getOrderDetails();
    Common.getCurrency().then((value) {
      currency = value;
    });
    super.initState();
  }

  Future<void> getOrderDetails() async {
    if (mounted) {
      setState(() {
        orderDataLoading = true;
      });
    }
    await APIService.getOrderHistory(widget.orderID).then((value) {
      if (value['response_data'] != null && mounted) {
        setState(() {
          if (mounted) {
            setState(() {
              order = value['response_data'];

              String? firstName = '', lastName = '';
              if (order!['order']['user'] != null &&
                  order!['order']['user']['firstName'] != null)
                firstName = order!['order']['user']['firstName'];
              if (order!['order']['user'] != null &&
                  order!['order']['user']['lastName'] != null)
                lastName = order!['order']['user']['lastName'];
              mobileNumber = '${order!['order']['user']['mobileNumber'] ?? ""}';
              fullName = '$firstName $lastName';
              if (order!['order']['address'] != null) {
                deliveryAddress =
                    '${order!['order']['address']['flatNo']}, ${order!['order']['address']['apartmentName']}, ${order!['order']['address']['address']}';
              }
              orderDataLoading = false;
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            orderDataLoading = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          orderDataLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPrimary(context, "ORDER_DETAILS") as PreferredSizeWidget?,
      backgroundColor: greyA,
      body: orderDataLoading
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                buildDescriptionCard(fullName, deliveryAddress),
              ],
            ),
    );
  }

  Widget buildDescriptionCard(fullName, deliveryAddress) {
    return GFCard(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(fullName, style: titleXLargeBPSB()),
          SizedBox(height: 20),
          Text(MyLocalizations.of(context)!.getLocalizations("ADDRESS", true),
              style: keyText()),
          Text(deliveryAddress, style: titleLargeBPM()),
          SizedBox(height: 20),
          Text(MyLocalizations.of(context)!.getLocalizations("ITEMS", true),
              style: keyText()),
          ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: order!['cart']['products'].length,
              itemBuilder: (BuildContext context, int index) {
                List products = order!['cart']['products'];
                return Text(
                  "${products[index]['productName']} (${products[index]['unit']}) X ${products[index]['quantity']}",
                  style: titleLargeBPM(),
                );
              }),
          SizedBox(height: 20),
          buildFinalTotalBlock(context),
        ],
      ),
    );
  }

  Widget buildFinalTotalBlock(context) {
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: [
              orderSummary(context, "ORDER_ID",
                  "#${order!['order']['orderID'].toString()}"),
              orderSummary(context, "DATE", order!['order']['deliveryDate']),
              orderSummary(context, "TIME", order!['order']['deliveryTime']),
              orderSummary(context, "PAYMENT", order!['order']['paymentType']),
              orderSummary(
                  context, "PAYMENT_STATUS", order!['order']['paymentStatus']),
              orderSummary(context, "SUB_TOTAL",
                  "$currency${order!['cart']['subTotal'].toDouble().toStringAsFixed(2)}"),
              order!['cart']['tax'] == 0
                  ? Container()
                  : orderSummary(context, "TAX",
                      "$currency${order!['cart']['tax'].toDouble().toStringAsFixed(2)}"),
              order!['cart']['deliveryCharges'] == 0
                  ? Container()
                  : orderSummary(context, "DELIVERY_CHARGES",
                      "$currency${order!['cart']['deliveryCharges'].toDouble().toStringAsFixed(2)}"),
              order!['cart']['couponAmount'] == 0
                  ? Container()
                  : orderSummary(context, "DISCOUNT",
                      "$currency${order!['cart']['couponAmount'].toDouble().toStringAsFixed(2)}"),
              order!['cart']['walletAmount'] == 0
                  ? Container()
                  : orderSummary(context, "WALLET",
                      "$currency${order!['cart']['walletAmount'].toDouble().toStringAsFixed(2)}"),
              Divider(),
              orderSummary(
                  context, "NOTE", "${order!['order']['deliveryInstruction']}"),
              Divider(),
              orderSummary(context, "TOTAL",
                  "$currency${order!['cart']['grandTotal'].toDouble().toStringAsFixed(2)}"),
              Divider(),
            ],
          ),
        )
      ],
    );
  }
}
