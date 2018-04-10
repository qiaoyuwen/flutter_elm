import 'package:flutter/material.dart';
import '../components/foot_bar.dart';
import '../style/style.dart';
import '../components/head_bar.dart';

class Order extends StatefulWidget {
  @override
  createState() => new OrderState();
}

class OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new HeadBar(
        title: '订单列表',
        leadingType: HeadBarLeadingType.goBack,
        showUser: false,
      ),
      body: new Column(
        children: <Widget>[
        ],
      ),
      bottomNavigationBar: new FootBar(currentIndex: 2,),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }
}