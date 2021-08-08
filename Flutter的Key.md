Flutter的Key

Key是一个抽象类

LocalKey,用作diff算法的核心所在,用于Element和Widget的比较.

- ValueKey 以一个数据为key,如数字,字符串
- ObjectKey 以一个Object对象作为key
- UniqueKey 保证key的唯一性,(一旦使用UniqueKey就不存在Element的复用了).

GlobalKey

GlobalKey可以获取到对应的Widget的State对象.

```
import 'package:flutter/material.dart';

class GlobalKeyDemo extends StatelessWidget {
  final GlobalKey<_ChildPageState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GlobalKeyDemo'),
      ),
      body: ChildPage(
        key: _globalKey,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _globalKey.currentState.data =
              'old:' + _globalKey.currentState.count.toString();
          _globalKey.currentState.count++;
          _globalKey.currentState.setState(() {});
        },
      ),
    );
  }
}

class ChildPage extends StatefulWidget {
  ChildPage({Key key}) : super(key: key);
  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  int count = 0;
  String data = 'hello';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(count.toString()),
          Text(data),
        ],
      ),
    );
  }
}

```





