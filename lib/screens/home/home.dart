import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/location.dart';
import '../../models/socket.dart';
import '../../styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'tracking.dart';

class Home extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  Home({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool assignedOrderLoading = false, lastApiCall = false;
  List assignedOrdersList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int productLimt = 10, productIndex = 0, totalProduct = 1;
  @override
  void initState() {
    if (mounted) {
      setState(() {
        assignedOrderLoading = true;
      });
    }
    getAssignedOrders(productIndex);
    super.initState();
  }

  Future<void> getAssignedOrders(productIndex) async {
    await APIService.getAssignedOrder(productIndex, productLimt).then((value) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          assignedOrderLoading = false;
        });
      }
      if (value['response_code'] == 200 && mounted) {
        setState(() {
          assignedOrdersList.addAll(value['response_data']);
          totalProduct = value["total"];
          int index = assignedOrdersList.length;
          if (lastApiCall == true) {
            productIndex++;
            if (index < totalProduct) {
              getAssignedOrders(productIndex);
            } else {
              if (index == totalProduct) {
                if (mounted) {
                  lastApiCall = false;
                  getAssignedOrders(productIndex);
                }
              }
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            assignedOrdersList = [];
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          assignedOrdersList = [];
          assignedOrderLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationModel>(context, listen: false).requestLocation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(MyLocalizations.of(context).getLocalizations("HOME"),
            style: titleWPS()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: () {
          setState(() {
            productLimt = 10;
            productIndex = 0;
            totalProduct = 1;
            getAssignedOrders(productIndex);
          });
        },
        child: assignedOrderLoading == true
            ? SquareLoader()
            : ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("ACTIVE_REQUESTS"),
                      style: titleBPS(),
                    ),
                  ),
                  assignedOrdersList.length > 0
                      ? ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: assignedOrdersList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildOrderCard(
                                assignedOrdersList[index], index, context);
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
                                      .getLocalizations("NO_ACTIVE_REQUESTS"),
                                  style: pageHeader()),
                            ],
                          ),
                        )
                ],
              ),
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      content: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      height: 15,
                      child: SvgPicture.asset('lib/assets/icons/customer.svg')),
                  Text(
                      MyLocalizations.of(context)
                          .getLocalizations("CUSTOMER", true),
                      style: keyText()),
                  Text(fullName, style: keyValue())
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Container(
                  height: 15,
                  width: 20,
                  child: Icon(Icons.timer, color: greyB, size: 15)),
              Text(MyLocalizations.of(context).getLocalizations("DATE", true),
                  style: keyText()),
              Text(order['deliveryDate'] + ' ' + order['deliveryTime'],
                  style: keyValue())
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Container(
                height: 15,
                child: SvgPicture.asset('lib/assets/icons/hash.svg'),
              ),
              Text(
                  MyLocalizations.of(context)
                      .getLocalizations("ORDER_ID", true),
                  style: keyText()),
              Text("#${order['orderID'].toString()}", style: keyValue())
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              Container(
                height: 15,
                child: SvgPicture.asset('lib/assets/icons/location.svg'),
              ),
              Row(children: [
                Text(
                    MyLocalizations.of(context)
                        .getLocalizations("ADDRESS", true),
                    style: keyText()),
                SizedBox(width: 20),
                order['deliveryAddress'] != null
                    ? Container(
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        child: Text(order['deliveryAddress']['addressType'],
                            style: TextStyle(
                                color: greyA,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)))
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
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Text(deliveryAddress,
                textAlign: TextAlign.center, style: titleBPM()),
          ),
          SizedBox(height: 10),
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
              // Provider.of<OrderModel>(context, listen: false)
              //     .updateOrder(order, index);
              // service.getSocketInstance.orderEmitForAcceptReject(
              //     service.getSocketInstance.getSocket(), order);
              Map body = {"order": order};
              APIService.orderAcceptOrRejectApi(body).then((value) {
                if (value['response_code'] == 200 && mounted) {
                  setState(() {
                    assignedOrdersList.removeAt(index);
                  });
                } else {
                  if (mounted) {
                    setState(() {});
                  }
                }
              }).catchError((e) {
                if (mounted) {
                  setState(() {});
                }
              });
            }
          },
          size: GFSize.LARGE,
          child: order['isLoading'] != null &&
                  order['isLoading'] &&
                  !order['isAcceptedByDeliveryBoy']
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).getLocalizations("REJECT"),
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
                MyLocalizations.of(context).getLocalizations("TRACK"),
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
              Map body = {"order": order};
              APIService.orderAcceptOrRejectApi(body).then((value) {
                if (value['response_code'] == 200 && mounted) {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Tracking(
                                orderID: order['_id'].toString(),
                              )),
                    );
                  });
                } else {
                  if (mounted) {
                    setState(() {
                      order['isAcceptedByDeliveryBoy'] = false;
                    });
                  }
                }
              }).catchError((e) {
                if (mounted) {
                  setState(() {
                    order['isAcceptedByDeliveryBoy'] = false;
                  });
                }
              });
            }
            // Provider.of<OrderModel>(context, listen: false)
            //     .updateOrder(order, index);
            // service.getSocketInstance.orderEmitForAcceptReject(
            //     service.getSocketInstance.getSocket(), order);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => Tracking(
            //             orderID: order['orderID'].toString(),
            //           )),
            // );
            // }
          },
          size: GFSize.LARGE,
          child: order['isLoading'] != null &&
                  order['isLoading'] &&
                  order['isAcceptedByDeliveryBoy']
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).getLocalizations("ACCEPT_TRACK"),
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
