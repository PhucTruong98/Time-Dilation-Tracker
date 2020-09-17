import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';

class Utility {
  List<double> getTimeDilation(double velocity, double time) {
    List<double> result = new List();
    double c_value = 3e8;
    double lorenzVal = sqrt(1 - pow(velocity / c_value, 2));
    //(velocity < 100)?  lorenzVal = (1 - pow(velocity/c_value, 2)/2) : lorenzVal = sqrt(1 - pow(velocity/c_value, 2));
    double properTime = time * lorenzVal;
    double timeDifference = (time - properTime);
    print("lorenz debug" +
        lorenzVal.toString() +
        properTime.toString() +
        timeDifference.toString());

    result.add(lorenzVal);
    result.add(properTime);
    result.add(timeDifference);
    print("lorenz debug" +
        result[0].toString() + //
        result[1].toString() + //
        result[2].toString()); //

    return result;
  }

  Color getLineColor(double speed)
  {
    if(speed < 5)
      {
        return Colors.green[50];
      }
    if(speed < 9)
    {
      return Colors.green[100];
    }
    if(speed < 15)
    {
      return Colors.green[400];
    }
    if(speed < 20)
    {
      return Colors.green[500];
    }
    if(speed < 24)
    {
      return Colors.green[600];
    }
    else return Colors.redAccent;
  }

  String setting1 = "default 1";
  String setting2 = "default 2";
  String setting3 = "default 3";

  String getSettingOne() {
    return setting1;
  }

  String getSettingTwo() {
    return setting2;
  }

  String getSettingThree() {
    return setting3;
  }

  void setSetting1(String newSetting) {
    setting1 = newSetting;
  }

  void setSetting2(String newSetting) {
    setting2 = newSetting;
  }

  void setSetting3(String newSetting) {
    setting3 = newSetting;
  }
}
