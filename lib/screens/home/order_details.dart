import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/order.dart';
import '../../styles/styles.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final String orderID;
  OrderDetails({Key key, this.orderID}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map<String, dynamic> order;

  Map<String, dynamic> findOrderByID(List orders, String orderID) =>
      orders.firstWhere((element) => element['_id'] == orderID);
  String currency;
  bool currencyLoading = false;
  @override
  void initState() {
    getCurrency();
    super.initState();
  }

  getCurrency() async {
    if (mounted) {
      setState(() {
        currencyLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    print(currency);
    if (currency != null) {
      if (mounted) {
        setState(() {
          currencyLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          'Order Details',
          style: titleWPS(),
        ),
        centerTitle: true,
      ),
      backgroundColor: greyA,
      body: currencyLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<OrderModel>(builder: (context, data, child) {
              order = findOrderByID(data.deliveredOrders, widget.orderID);
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
                    '${order['deliveryAddress']['flatNo']}, ${order['deliveryAddress']['apartmentName']}, ${order['deliveryAddress']['address']}';
              }
              return ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '# Order ID: ',
                              style: subTitleLargeBPM(),
                            ),
                            Text(
                              order['orderID'],
                              style: subTitleSmallBPM(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              DateFormat("HH:MM a, dd/MM/yyyy")
                                  .format(DateTime.parse(order['createdAt']))
                                  .toString(),
                              style: subTitleSmallBPM(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
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
          SizedBox(
            height: 20,
          ),
          Text(
            'Address',
            style: titleXSmallBPR(),
          ),
          Text(
            deliveryAddress,
            style: titleLargeBPM(),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Items',
            style: titleXSmallBPR(),
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
          SizedBox(
            height: 40,
          ),
          buildFinalTotalBlock(),
        ],
      ),
    );
  }

  Widget buildFinalTotalBlock() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: AlignmentDirectional.center,
            height: 64,
            decoration: BoxDecoration(
                border: Border.all(color: greyB),
                borderRadius: BorderRadius.circular(10),
                color: greyA),
            child: Text(DateFormat("HH:MM a, dd/MM/yyyy")
                .format(DateTime.parse(order['updatedAt']))
                .toString()),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: <Widget>[
            Text(
              'Total',
              style: titleXSmallBPR(),
            ),
            Text(
              '$currency${order['grandTotal']}',
              style: titleXLargeGPB(),
            )
          ],
        )
      ],
    );
  }
}
