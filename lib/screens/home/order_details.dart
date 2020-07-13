import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import '../../models/order.dart';
import '../../styles/styles.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    getOrderDetails();
    super.initState();
  }

  Future<void> getOrderDetails() async {
    if (mounted) {
      setState(() {
        orderDataLoading = true;
      });
    }
    await APIService.getOrderHistory(widget.orderID).then((value) {
      if (value['response_code'] == 200 && mounted) {
        setState(() {
          if (mounted) {
            setState(() {
              order = value['response_data'];

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
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          MyLocalizations.of(context).getLocalizations("ORDER_DETAILS"),
          style: titleWPS(),
        ),
        centerTitle: true,
      ),
      backgroundColor: greyA,
      body: orderDataLoading
          ? SquareLoader()
          : Consumer<OrderModel>(builder: (context, data, child) {
              // order = findOrderByID(data.deliveredOrders, widget.orderID);
              currency = data.currency;
              String firstName = '',
                  lastName = '',
                  fullName = '',
                  deliveryAddress = '';
              if (order['user'] != null && order['user']['firstName'] != null) {
                firstName = order['user']['firstName'];
              }
              if (order['user'] != null && order['user']['lastName'] != null) {
                lastName = order['user']['lastName'];
              }
              fullName = '$firstName $lastName';
              if (order['deliveryAddress'] != null) {
                deliveryAddress =
                    '${order['deliveryAddress']['flatNo'] == null || order['deliveryAddress']['flatNo'] == "" ? "" : order['deliveryAddress']['flatNo'] + ", "} ${order['deliveryAddress']['apartmentName'] == null || order['deliveryAddress']['apartmentName'] == "" ? "" : order['deliveryAddress']['apartmentName'] + ", "} ${order['deliveryAddress']['address']}';
              }
              return ListView(
                children: <Widget>[
                  buildDescriptionCard(fullName, deliveryAddress),
                ],
              );
            }),
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
              itemCount: order['cart']['cart'].length,
              itemBuilder: (BuildContext context, int index) {
                List products = order['cart']['cart'];
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
                          "#${order['orderID'].toString()}",
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
                          .getLocalizations("DELIVERD", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat("HH:MM a, dd/MM/yyyy")
                              .format(DateTime.parse(order['updatedAt']))
                              .toString(),
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
                          order['deliveryDate'],
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
                          order['deliveryTime'],
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
                          .getLocalizations("DELIVERY_TYPE", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          order['deliveryType'],
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
                          order['paymentType'] == 'COD'
                              ? MyLocalizations.of(context)
                                  .getLocalizations("CASH_ON_DELIVERY")
                              : order['paymentType'] == 'CARD'
                                  ? MyLocalizations.of(context)
                                      .getLocalizations("PAYBYCARD")
                                  : order['paymentType'],
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
                          "$currency${order['subTotal'].toDouble().toStringAsFixed(2)}",
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
                          .getLocalizations("DELIVERY_CHARGES", true),
                      style: keyText()),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$currency${order['deliveryCharges'].toDouble().toStringAsFixed(2)}",
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
                          "$currency${order['grandTotal'].toDouble().toStringAsFixed(2)}",
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
