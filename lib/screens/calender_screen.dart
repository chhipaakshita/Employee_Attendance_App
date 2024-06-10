

import 'package:employee_attendance_app/models/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

import '../services/attendance_service.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final attedanceData = Provider.of<AttendanceModel>;
  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20,top: 60,bottom: 10),
          child: Text(
            "My Attendance",style: TextStyle(fontSize: 25),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(attendanceService.attendanceHistoryMonth,style: TextStyle(fontSize: 25),),
            OutlinedButton(onPressed: () async{
              final selectedDate = await
              SimpleMonthYearPicker.showMonthYearPickerDialog(context: context,disableFuture: true);
              String pickMonth = DateFormat('MMMM yyyy').format(selectedDate);
              attendanceService.attendanceHistoryMonth = pickMonth;
            }, child: Text('Pick a Month'))
          ],
        ),
        Expanded(
            child: FutureBuilder(
                future: attendanceService.getAttendanceHistory(),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                        if(snapshot.data.length>0){
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context,index){
                                    AttendanceModel attendanceData = snapshot.data[index];
                                    return Container(
                                      margin: EdgeInsets.only(
                                        top: 12,left: 20,right: 20,bottom: 20
                                      ),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(2, 3))
                                        ],
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Container(
                                               // margin: EdgeInsets.only(),
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Center(
                                                  child: Text(DateFormat("EE \n dd").format(attendanceData.createdAt),style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                      fontWeight: FontWeight.bold
                                                  ),),
                                                ),
                                              )
                                          ),
                                           Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("Check in",style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black45,
                                                  ),),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Divider(),
                                                  ),
                                                  Text(attendanceData.check_in)
                                                ],
                                              )
                                          ),
                                           Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("Check OUT",style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black45,
                                                  ),),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Divider(),
                                                  ),
                                                   Text(attendanceData.check_out.toString() ?? '--/--' ,style : TextStyle(fontSize:25))
                                                ],
                                              )
                                          ),
                                          SizedBox(width: 15,)
                                        ],
                                      ),
                                    );
                                }
                            );
                        }else{
                          return Center(child: Text('No data Available',style: TextStyle(fontSize: 25),),);
                        }
                    }
                    return LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.grey
                    );
                }
            )
        )
      ],
    );
  }
}
