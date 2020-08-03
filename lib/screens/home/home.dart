import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/services/socket.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/location.dart';
import '../../models/socket.dart';
import '../../styles/styles.dart';
import 'tracking.dart';

class Home extends StatefulWidget {
  final Map localizedValues;
  final String locale;

  Home({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool assignedOrderLoading = false,
      lastApiCall = false,
      isOrderAccept = false,
      isOrderReject = false,
      locationLoading = false,
      isNewOrderAccept = false,
      isNewOrderReject = false;
  List assignedOrdersList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int productLimt = 10, productIndex = 0, totalProduct = 1, orderIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var adminData;
  SocketService socket = SocketService();
  Map newOrder;
  @override
  void initState() {
    if (mounted) {
      setState(() {
        assignedOrderLoading = true;
      });
    }
    getAssignedOrders(productIndex);
    getAdminInfo();
    intSocket();
    super.initState();
  }

  intSocket() {
    Common.getAccountID().then((id) {
      if (id != null) {
        socket.getSocket().on('new-order-delivery-boy-$id', (data) {
          if (data != null && mounted) {
            setState(() {
              newOrder = data;
            });
          }
        });
      }
    });
  }

  void getAdminInfo() async {
    if (mounted) {
      setState(() {
        locationLoading = true;
      });
    }
    await APIService.getLocationformation().then((info) {
      if (info != null && info['response_data'] != null) {
        setState(() {
          if (info['response_data']['location'] != null) {
            adminData = info['response_data'];
            locationLoading = false;
          } else {
            if (mounted) {
              setState(() {
                adminData = info['response_data'];
                adminData['location'] = {
                  "latitude": 12.8718,
                  "longitude": 77.6022
                };
                locationLoading = false;
              });
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            adminData['location'] = {"latitude": 12.8718, "longitude": 77.6022};
            locationLoading = false;
          });
        }
      }
    });
  }

  Future<void> getAssignedOrders(productIndex) async {
    await APIService.getAssignedOrder(productLimt, productIndex).then((value) {
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          assignedOrderLoading = false;
        });
      }
      if (value['response_data'] != null && mounted) {
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

  orderAccept(order) {
    if (mounted) {
      setState(() {
        isOrderAccept = true;
      });
    }

    APIService.orderAcceptApi(order['_id'].toString()).then((value) {
      showSnackbar(value['response_data']);
      if (value['response_data'] != null && mounted) {
        setState(() {
          isOrderAccept = false;
          order['isAcceptedByDeliveryBoy'] = true;
          var result = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tracking(
                  orderID: order['_id'].toString(),
                  adminData: adminData,
                  customerInfo: order['address']),
            ),
          );
          result.then((value) {
            if (value != null) {
              productLimt = 10;
              productIndex = 0;
              totalProduct = 1;
              assignedOrdersList = [];

              getAssignedOrders(productIndex);
              getAdminInfo();
            }
          });
        });
      } else {
        if (mounted) {
          setState(() {
            isOrderAccept = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          isOrderAccept = false;
        });
      }
    });
  }

  orderReject(order, index) {
    if (mounted) {
      setState(() {
        isOrderReject = true;
      });
    }

    APIService.orderRejectApi(order['_id'].toString()).then((value) {
      showSnackbar(value['response_data']);
      if (value['response_data'] != null && mounted) {
        setState(() {
          isOrderReject = false;
          assignedOrdersList.removeAt(index);
          order['isAcceptedByDeliveryBoy'] = false;
        });
      } else {
        if (mounted) {
          setState(() {
            isOrderReject = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          isOrderAccept = false;
        });
      }
    });
  }

  newOrderAccept(order) {
    if (mounted) {
      setState(() {
        isNewOrderAccept = true;
      });
    }

    APIService.orderAcceptApi(order['orderId'].toString()).then((value) {
      showSnackbar(value['response_data']);
      if (value['response_data'] != null && mounted) {
        setState(() {
          isNewOrderAccept = false;
          setState(() {
            productLimt = 10;
            productIndex = 0;
            totalProduct = 1;
            assignedOrdersList = [];
            getAssignedOrders(productIndex);
            newOrder = null;
          });
        });
      } else {
        if (mounted) {
          setState(() {
            isNewOrderAccept = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          isNewOrderAccept = false;
        });
      }
    });
  }

  newOrderReject(order) {
    if (mounted) {
      setState(() {
        isNewOrderReject = true;
      });
    }

    APIService.orderRejectApi(order['orderId'].toString()).then((value) {
      showSnackbar(value['response_data']);
      if (value['response_data'] != null && mounted) {
        setState(() {
          isNewOrderReject = false;
          newOrder = null;
        });
      } else {
        if (mounted) {
          setState(() {
            isNewOrderReject = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          isNewOrderReject = false;
        });
      }
    });
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationModel>(context, listen: false).requestLocation();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(MyLocalizations.of(context).getLocalizations("HOME"),
            style: titleWPS()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: GFFloatingWidget(
        showblurness: newOrder == null ? false : true,
        verticalPosition: 50,
        child: newOrder == null
            ? Container()
            : GFAlert(
                title: MyLocalizations.of(context)
                        .getLocalizations("ORDER_ID", true) +
                    ' #${newOrder['orderID']}',
                contentChild: buildNewOrderCard(newOrder),
                bottombar: Row(
                  children: <Widget>[
                    buildNeworderRejectButton(newOrder),
                    SizedBox(
                      width: 12,
                    ),
                    buildNeworderAcceptButton(newOrder),
                  ],
                )),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          onRefresh: () {
            setState(() {
              productLimt = 10;
              productIndex = 0;
              totalProduct = 1;
              assignedOrdersList = [];
              getAssignedOrders(productIndex);
            });
          },
          child: assignedOrderLoading == true || locationLoading == true
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
      ),
    );
  }

  Widget buildNewOrderCard(order) {
    String fullName = '', firstName = '', lastName = '', deliveryAddress = '';
    if (order['user'] != null && order['user']['firstName'] != null) {
      firstName = order['user']['firstName'];
    }
    if (order['user'] != null && order['user']['lastName'] != null) {
      lastName = order['user']['lastName'];
    }
    fullName = '$firstName $lastName';
    if (order['address'] != null) {
      deliveryAddress =
          '${order['address']['flatNo']}, ${order['address']['apartmentName']}, ${order['address']['address']}';
    }
    return GFCard(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      content: Column(
        children: <Widget>[
          Row(
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
              Expanded(
                child: Text(
                  order['deliveryDate'] + ', ' + order['deliveryTime'],
                  style: keyValue(),
                ),
              )
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
                order['address'] != null
                    ? Container(
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        child: Text(order['address']['addressType'],
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
        ],
      ),
    );
  }

  Widget buildNeworderRejectButton(order) {
    return Expanded(
      child: Container(
        height: 51,
        child: GFButton(
          onPressed: () {
            newOrderReject(order);
          },
          size: GFSize.LARGE,
          child: isNewOrderReject
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).getLocalizations("REJECT"),
                  style: titleGPBB(),
                ),
          color: greyB,
          type: GFButtonType.outline2x,
        ),
      ),
    );
  }

  Widget buildNeworderAcceptButton(order) {
    return Expanded(
      child: Container(
        height: 51,
        child: GFButton(
          onPressed: () {
            newOrderAccept(order);
          },
          size: GFSize.LARGE,
          child: isNewOrderAccept
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).getLocalizations("ACCEPT"),
                  style: titleGPBB(),
                ),
          textStyle: titleGPBB(),
          type: GFButtonType.outline2x,
          color: secondary,
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
    if (order['address'] != null) {
      deliveryAddress =
          '${order['address']['flatNo']}, ${order['address']['apartmentName']}, ${order['address']['address']}';
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
              Expanded(
                child: Text(
                  order['deliveryDate'] + ', ' + order['deliveryTime'],
                  style: keyValue(),
                ),
              )
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
                order['address'] != null
                    ? Container(
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        child: Text(order['address']['addressType'],
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
            setState(() {
              orderIndex = index;
            });
            orderReject(order, index);
          },
          size: GFSize.LARGE,
          child: isOrderReject && orderIndex == index
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).getLocalizations("REJECT"),
                  style: titleGPBB(),
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
          var result = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Tracking(
                  orderID: order['_id'].toString(),
                  adminData: adminData,
                  customerInfo: order['address']),
            ),
          );
          result.then((value) {
            if (value != null) {
              productLimt = 10;
              productIndex = 0;
              totalProduct = 1;
              assignedOrdersList = [];
              getAssignedOrders(productIndex);
              getAdminInfo();
            }
          });
        },
        size: GFSize.LARGE,
        child: Text(
          MyLocalizations.of(context).getLocalizations("TRACK"),
          style: titleGPBB(),
        ),
        textStyle: titleGPBB(),
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
            setState(() {
              orderIndex = index;
            });
            orderAccept(order);
          },
          size: GFSize.LARGE,
          child: isOrderAccept && orderIndex == index
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).getLocalizations("ACCEPT_TRACK"),
                  style: titleGPBB(),
                ),
          textStyle: titleGPBB(),
          type: GFButtonType.outline2x,
          color: secondary,
        ),
      ),
    );
  }
}
