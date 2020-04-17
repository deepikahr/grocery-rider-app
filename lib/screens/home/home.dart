import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import '../../models/location.dart';
import '../../models/order.dart';
import '../../models/socket.dart';
import '../../styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'tracking.dart';

class Home extends StatelessWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  Home({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationModel>(context, listen: false).requestLocation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          MyLocalizations.of(context).home,
          style: titleWPS(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 16,
            ),
            child: Text(
              MyLocalizations.of(context).activeRequests,
              style: titleBPS(),
            ),
          ),
          Consumer<OrderModel>(
            builder: (context, data, child) {
              if (data == null || data.orders == null) {
                return Padding(
                    padding: EdgeInsets.only(top: 50), child: SquareLoader());
              } else if (data.orders.length > 0) {
                return ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildOrderCard(data.orders[index], index, context);
                    });
              } else {
                return Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 100,
                        color: greyB,
                      ),
                      Text(
                        MyLocalizations.of(context).noActiveRequests,
                        style: titleBPS(),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildOrderCard(order, index, context) {
    String fullName = '', firstName = '', lastName = '', deliveryAddress = '';
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
    return GFCard(
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
                child: SvgPicture.asset(
                  'lib/assets/icons/location.svg',
                ),
              ),
              Row(children: [
                Text(
                  MyLocalizations.of(context).address,
                  style: titleXSmallBPR(),
                ),
                SizedBox(width: 20),
                order['deliveryAddress'] != null
                    ? Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Text(order['deliveryAddress']['addressType'],
                            style: TextStyle(color: greyA, fontSize: 10)),
                      )
                    : Container(),
              ])
            ],
          ),
          Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              border: Border.all(color: greyB, width: 1),
              borderRadius: BorderRadius.circular(5),
              color: greyA,
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            child: Text(
              deliveryAddress,
              textAlign: TextAlign.center,
              style: titleBPM(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Consumer<SocketModel>(builder: (context, service, child) {
            return order['isAcceptedByDeliveryBoy']
                ? buildViewDetailsButton(context, order, index)
                : Row(
                    children: <Widget>[
                      buildRejectButton(context, order, index, service),
                      SizedBox(
                        width: 12,
                      ),
                      buildAcceptButton(context, order, index, service),
                    ],
                  );
          }),
        ],
      ),
    );
  }

  Widget buildRejectButton(context, order, index, service) {
    return Expanded(
      child: Container(
        height: 51,
        child: GFButton(
          onPressed: () {
            if (order['isLoading'] == null) {
              order['isLoading'] = true;
              order['isAcceptedByDeliveryBoy'] = false;
              Provider.of<OrderModel>(context, listen: false)
                  .updateOrder(order, index);
              service.getSocketInstance.orderEmitForAcceptReject(
                  service.getSocketInstance.getSocket(), order);
            }
          },
          size: GFSize.LARGE,
          child: order['isLoading'] != null &&
                  order['isLoading'] &&
                  !order['isAcceptedByDeliveryBoy']
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).REJECT,
                  style: titleGPB(),
                ),
          color: greyB,
          type: GFButtonType.outline2x,
        ),
      ),
    );
  }

  Widget buildViewDetailsButton(context, order, index) {
    return Container(
      height: 51,
      child: GFButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Tracking(
                      orderID: order['_id'].toString(),
                    )),
          );
        },
        size: GFSize.LARGE,
        child: order['isLoading'] != null &&
                order['isLoading'] &&
                !order['isAcceptedByDeliveryBoy']
            ? SquareLoader()
            : Text(
                MyLocalizations.of(context).TRACK,
                style: titleGPB(),
              ),
        textStyle: titleSPB(),
        type: GFButtonType.outline2x,
        color: primary,
        blockButton: true,
      ),
    );
  }

  Widget buildAcceptButton(context, order, index, service) {
    return Expanded(
      child: Container(
        height: 51,
        child: GFButton(
          onPressed: () {
            if (order['isLoading'] == null) {
              order['isLoading'] = true;
              order['isAcceptedByDeliveryBoy'] = true;
              Provider.of<OrderModel>(context, listen: false)
                  .updateOrder(order, index);
              service.getSocketInstance.orderEmitForAcceptReject(
                  service.getSocketInstance.getSocket(), order);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Tracking(
                          orderID: order['_id'].toString(),
                        )),
              );
            }
          },
          size: GFSize.LARGE,
          child: order['isLoading'] != null &&
                  order['isLoading'] &&
                  order['isAcceptedByDeliveryBoy']
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).accptRejest,
                  style: titleGPB(),
                ),
          textStyle: titleSPB(),
          type: GFButtonType.outline2x,
          color: secondary,
        ),
      ),
    );
  }
}
