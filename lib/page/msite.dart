import 'package:flutter/material.dart';
import '../components/component_utils.dart';
import '../style/style.dart';

class MSite extends StatefulWidget {
  MSite(num longitude, num latitude)
      : longitude = longitude,
        latitude = latitude,
        assert(longitude != null),
        assert(latitude != null);

  final num longitude;
  final num latitude;

  @override
  createState() => new MSiteState();
}

class MSiteState extends State<MSite> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      backgroundColor: Style.emptyBackgroundColor,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ComponentUtils.buildAppBar(
      context: context,
      title: '地址',
      centerTitle: true,
      leading: new IconButton(
        icon: new Icon(Icons.search),
        color: Style.backgroundColor,
        onPressed: _goSearch,
      ),
    );
  }

  Widget _buildBody() {
    return new ListView.builder(
      itemBuilder: (context, i) {

      },
    );
  }

  _goSearch() {

  }
}
