import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/loader.dart';

import '../../styles/styles.dart';

class OrderDetails extends StatefulWidget {
  final String orderID;
  final Map localizedValues;
  final String locale;

  OrderDetails({Key key, this.localizedValues, this.locale, this.orderID})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map order;
  String currency;
  bool orderDataLoading = false;
  var mobileNumber, fullName, deliveryAddress;

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

              String firstName = '', lastName = '';
              if (order['order']['user'] != null &&
                  order['order']['user']['firstName'] != null)
                firstName = order['order']['user']['firstName'];
              if (order['order']['user'] != null &&
                  order['order']['user']['lastName'] != null)
                lastName = order['order']['user']['lastName'];
              mobileNumber =
                  order['order']['user']['mobileNumber'].toString() ?? "";
              fullName = '$firstName $lastName';
              if (order['order']['address'] != null) {
                deliveryAddress =
                    '${order['order']['address']['flatNo']}, ${order['order']['address']['apartmentName']}, ${order['order']['address']['address']}';
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
      appBar:appBar(context,"ORDER_DETAILS"),
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
          Text(
            fullName,
            style: titleXLargeBPSB(),
          ),
          SizedBox(height: 20),
          Text(
            MyLocalizations.of(context).getLocalizations("ADDRESS", true),
            style: keyText(),
          ),
          Text(
            deliveryAddress,
            style: titleLargeBPM(),
          ),
          SizedBox(height: 20),
          Text(
            MyLocalizations.of(context).getLocalizations("ITEMS", true),
            style: keyText(),
          ),
          ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: order['cart']['products'].length,
              itemBuilder: (BuildContext context, int index) {
                List products = order['cart']['products'];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations("ORDER_ID", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "#${order['order']['orderID'].toString()}",
                          style: titleLargeBPM(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations("DATE", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          order['order']['deliveryDate'],
                          style: titleLargeBPM(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations("TIME", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          order['order']['deliveryTime'],
                          style: titleLargeBPM(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations("PAYMENT", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          order['order']['paymentType'] == 'COD'
                              ? MyLocalizations.of(context)
                                  .getLocalizations("CASH_ON_DELIVERY")
                              : order['order']['paymentType'] == 'CARD'
                                  ? MyLocalizations.of(context)
                                      .getLocalizations("PAYBYCARD")
                                  : order['order']['paymentType'],
                          style: titleLargeBPM(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations("SUB_TOTAL", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$currency${order['cart']['subTotal'].toDouble().toStringAsFixed(2)}",
                          style: titleLargeBPM(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              order['cart']['tax'] == 0
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            MyLocalizations.of(context)
                                .getLocalizations("TAX", true),
                            style: keyText()),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$currency${order['cart']['tax'].toDouble().toStringAsFixed(2)}",
                                style: titleLargeBPM(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              order['cart']['deliveryCharges'] == 0
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            MyLocalizations.of(context)
                                .getLocalizations("DELIVERY_CHARGES", true),
                            style: keyText()),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$currency${order['cart']['deliveryCharges'].toDouble().toStringAsFixed(2)}",
                                style: titleLargeBPM(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations("TOTAL", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$currency${order['cart']['grandTotal'].toDouble().toStringAsFixed(2)}",
                          style: titleLargeBPM(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
