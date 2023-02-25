import 'package:flutter/material.dart';

class LoadingWidget {
  static Widget SmallLoading (){
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.deepOrange,valueColor: AlwaysStoppedAnimation(Colors.white),strokeWidth: 2.5,
      ),
    );
  }
}