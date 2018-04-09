import 'package:flutter/material.dart';
import '../components/foot_bar.dart';
import '../style/style.dart';

class Order extends StatefulWidget {
  @override
  createState() => new OrderState();
}

class OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: new Text('订单列表'),
        centerTitle: true,
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