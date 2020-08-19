import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:grocerydelivery/widgets/normalText.dart';

import '../../styles/styles.dart';
import 'order_details.dart';

class History extends StatefulWidget {
  final Map localizedValues;
  final String locale;

  History({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool deliverdOrderLoading = false, lastApiCall = false;
  List deliverdOrdersList = [];
  int productLimt = 10, productIndex = 0, totalProduct = 1;

  @override
  void initState() {
    if (mounted) {
      setState(() {
        deliverdOrderLoading = true;
      });
    }
    getDeliverdInfo(productIndex);
    super.initState();
  }

  Future<void> getDeliverdInfo(productIndex) async {
    await APIService.getDeliverdOrder(productLimt, productIndex).then((value) {
      if (mounted) {
        setState(() {
          deliverdOrderLoading = false;
        });
      }
      if (value['response_data'] != null && mounted) {
        setState(() {
          deliverdOrdersList.addAll(value['response_data']);
          totalProduct = value["total"];
          int index = deliverdOrdersList.length;
          if (lastApiCall == true) {
            productIndex++;
            if (index < totalProduct) {
              getDeliverdInfo(productIndex);
            } else {
              if (index == totalProduct) {
                if (mounted) {
                  lastApiCall = false;
                  getDeliverdInfo(productIndex);
                }
              }
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            deliverdOrdersList = [];
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          deliverdOrdersList = [];
          deliverdOrderLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarPrimary(context, "HISTORY"),
      body: deliverdOrderLoading == true
          ? SquareLoader()
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: Text(
                    MyLocalizations.of(context)
                        .getLocalizations("COMPLETED_REQUESTS"),
                    style: titleBPS(),
                  ),
                ),
                deliverdOrdersList.length > 0
                    ? ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: deliverdOrdersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildOrderCard(
                              context, deliverdOrdersList[index], index);
                        })
                    : Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: 100,
                              color: greyB,
                            ),
                            Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("NO_DELIVERED_ORDERS"),
                              style: titleBPS(),
                            ),
                          ],
                        ),
                      )
              ],
            ),
    );
  }

  Widget buildOrderCard(context, order, index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              orderID: order['_id'].toString(),
            ),
          ),
        );
      },
      child: GFCard(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        content: Column(
          children: <Widget>[
            SizedBox(height: 5),
            buildOrder(
                context,
                Container(
                    height: 15,
                    width: 20,
                    child: Icon(Icons.timer, color: greyB, size: 15)),
                "DATE",
                order['deliveryDate'] + ', ' + order['deliveryTime'],
                false),
            SizedBox(height: 5),
            buildOrder(
                context,
                Container(
                  height: 15,
                  child: SvgPicture.asset(
                    'lib/assets/icons/hash.svg',
                  ),
                ),
                "ORDER_ID",
                "#${order['orderID'].toString()}",
                false),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
