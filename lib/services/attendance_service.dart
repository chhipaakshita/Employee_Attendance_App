

import 'dart:core';
import 'package:employee_attendance_app/models/attendance_model.dart';
import 'package:employee_attendance_app/services/location_service.dart';
import 'package:employee_attendance_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/constant.dart';

class AttendanceService extends ChangeNotifier{
  final SupabaseClient _supabase = Supabase.instance.client;
  AttendanceModel? attendanceModel;
  String todayDate = DateFormat("dd MMMM yyyy").format(DateTime.now());

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
  String _attendanceHistoryMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String get attendanceHistoryMonth => _attendanceHistoryMonth;
  set attendanceHistoryMonth(String value){
    _attendanceHistoryMonth = value;
    notifyListeners();
  }

  Future getTodayAttendance() async{
    final List result = await _supabase
        .from(Constant.attendanceTable)
        .select()
        .eq("employee_id", _supabase.auth.currentUser!.id)
        .eq('date', todayDate);
        if(result.isNotEmpty ){
          attendanceModel = AttendanceModel.fromJson(result.first);
        }
        notifyListeners();
  }
  Future markAttendance(BuildContext context) async{
    Map? getLocation = await LocationService().initializeAndGetLocation(context);
      print(DateFormat('HH:mm').format(DateTime.now()));
      print(_supabase.auth.currentUser!.id);
      print(todayDate);
      if(getLocation != null){
        if(attendanceModel?.check_in == null){
          print("lllllll");
          await _supabase.from(Constant.attendanceTable).insert({
            'employee_id':_supabase.auth.currentUser!.id,
            'date': todayDate,
            'check_in':DateFormat('HH:mm').format(DateTime.now()),
            'check_in_location':getLocation
          });
        }else if(attendanceModel?.check_out == null){
          await _supabase
              .from(Constant.attendanceTable)
              .update({
            'check_out':DateFormat('HH:mm').format(DateTime.now()),
            'check_out_location':getLocation
          }).eq('employee_id', _supabase.auth.currentUser!.id)
              .eq('date', todayDate);
        }else{
          Utils.showSnackbar("You have already check out today", context);
        }
        getTodayAttendance();
      }else{
        Utils.showSnackbar("Not able to get your location", context,color: Colors.red);
        getTodayAttendance();
      }
  }
  Future<List<AttendanceModel>> getAttendanceHistory() async {
          final List data = await _supabase
              .from(Constant.attendanceTable)
              .select()
              .eq('employee_id', _supabase.auth.currentUser!.id)
              .textSearch('date', "'$attendanceHistoryMonth'",config: 'english')
              .order('created_at',ascending: false);
          return data.map((attendance) => AttendanceModel.fromJson(attendance)).toList();
  }
}