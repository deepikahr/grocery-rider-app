import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerydelivery/services/localizations.dart';
import '../../models/order.dart';
import '../../styles/styles.dart';
import 'package:getwidget/getwidget.dart';
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
  String currency;

  Map<String, dynamic> findOrderByID(List orders, String orderID) =>
      orders.firstWhere((element) => element['_id'] == orderID);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          MyLocalizations.of(context).orderDetails,
          style: titleWPS(),
        ),
        centerTitle: true,
      ),
      backgroundColor: greyA,
      body: Consumer<OrderModel>(builder: (context, data, child) {
        order = findOrderByID(data.deliveredOrders, widget.orderID);
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
              '${order['deliveryAddress']['flatNo']}, ${order['deliveryAddress']['apartmentName']}, ${order['deliveryAddress']['address']}';
        }
        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '# ${MyLocalizations.of(context).orderId}',
                        style: subTitleLargeBPM(),
                      ),
                      Text(
                        order['orderID'].toString(),
                        style: subTitleSmallBPM(),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        DateFormat('hh:mm a, dd/MM/yyyy')
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                order['appTimestamp']))
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
            MyLocalizations.of(context).address,
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
            MyLocalizations.of(context).items,
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
          buildFinalTotalBlock(context),
        ],
      ),
    );
  }

  Widget buildFinalTotalBlock(context) {
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
              MyLocalizations.of(context).total,
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
