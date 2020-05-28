import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import '../../models/order.dart';
import '../../styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'order_details.dart';

class History extends StatelessWidget {
  final Map localizedValues;
  final String locale;
  History({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          MyLocalizations.of(context).history,
          style: titleWPS(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Text(
              MyLocalizations.of(context).completedRequests,
              style: titleBPS(),
            ),
          ),
          Consumer<OrderModel>(
            builder: (context, data, child) {
              if (data.deliveredOrders == null) {
                return Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: SquareLoader(),
                );
              }
              if (data.deliveredOrders.length > 0) {
                return ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.deliveredOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildOrderCard(
                          context, data.deliveredOrders[index], index);
                    });
              } else {
                return Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Column(children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 100,
                        color: greyB,
                      ),
                      Text(
                        MyLocalizations.of(context).noDeliveredOrders,
                        style: titleBPS(),
                      ),
                    ]));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildOrderCard(context, order, index) {
    String fullName = '', firstName = '', lastName = '';
    if (order['user'] != null && order['user']['firstName'] != null) {
      firstName = order['user']['firstName'];
    }
    if (order['user'] != null && order['user']['lastName'] != null) {
      lastName = order['user']['lastName'];
    }
    fullName = '$firstName $lastName';
    print(order);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetails(
                    orderID: order['_id'].toString(),
                  )),
        );
      },
      child: GFCard(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        content: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 15,
                      child: SvgPicture.asset(
                        'lib/assets/icons/customer.svg',
                      ),
                    ),
                    Text(
                      MyLocalizations.of(context).customer,
                      style: titleXSmallBPR(),
                    ),
                    Text(
                      fullName,
                      style: titleXSmallBBPR(),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Container(
                  height: 15,
                  child: SvgPicture.asset(
                    'lib/assets/icons/hash.svg',
                  ),
                ),
                Text(
                  MyLocalizations.of(context).orderId,
                  style: titleXSmallBPR(),
                ),
                Text(
                  order['orderID'].toString(),
                  style: titleXSmallBBPR(),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Container(
                    height: 15,
                    child: Icon(
                      Icons.timer,
                      color: greyB,
                      size: 15,
                    )),
                Text(
                  MyLocalizations.of(context).timeDate,
                  style: titleXSmallBPR(),
                ),
                Text(
                  DateFormat('hh:mm a, dd/MM/yyyy')
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          order['appTimestamp']))
                      .toString(),
                  style: titleXSmallBBPR(),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
