// 菜单
import 'package:flutter/material.dart';

class HomeNav extends StatelessWidget {
  const HomeNav({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0xfff2f2f2), blurRadius: 5.0)],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.assignment_rounded, size: 32), Text('账单')],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.attach_money_rounded, size: 32), Text('预算')],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.verified_user_rounded, size: 32), Text('资产管理')],
            ),
          ),
        ],
      ),
    );
  }
}
