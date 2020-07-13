import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import '../../styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'order_details.dart';

class History extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  History({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool deliverdOrderLoading = false;
  List deliverdOrdersList;
  @override
  void initState() {
    getDeliverdInfo();
    super.initState();
  }

  Future<void> getDeliverdInfo() async {
    if (mounted) {
      setState(() {
        deliverdOrderLoading = true;
      });
    }
    await APIService.getDeliverdOrder().then((value) {
      if (mounted) {
        setState(() {
          deliverdOrderLoading = false;
        });
      }
      if (value['response_code'] == 200 && mounted) {
        setState(() {
          deliverdOrdersList = value['response_data'];
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
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          MyLocalizations.of(context).getLocalizations("HISTORY"),
          style: titleWPS(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
    String fullName = '', firstName = '', lastName = '';
    if (order['user'] != null && order['user']['firstName'] != null) {
      firstName = order['user']['firstName'];
    }
    if (order['user'] != null && order['user']['lastName'] != null) {
      lastName = order['user']['lastName'];
    }
    fullName = '$firstName $lastName';
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
                      MyLocalizations.of(context)
                          .getLocalizations("CUSTOMER", true),
                      style: keyText(),
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
                  MyLocalizations.of(context)
                      .getLocalizations("ORDER_ID", true),
                  style: keyText(),
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
                  MyLocalizations.of(context)
                      .getLocalizations("DATE_TIME", true),
                  style: keyText(),
                ),
                Expanded(
                  child: Text(
                    DateFormat('hh:mm a, dd/MM/yyyy, EEEE')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            order['appTimestamp']))
                        .toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleXSmallBBPR(),
                  ),
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
