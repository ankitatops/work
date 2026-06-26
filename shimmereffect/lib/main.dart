import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmereffect/shimmer.dart';


void main(){
  runApp(MaterialApp(home: ShimmerEx(),  routes:
  {
    'loading': (_) => LoadingListPage(),
  },
    debugShowCheckedModeBanner: false,));
}