

class AttendanceModel {
  final String id;
  final String date;
  final String check_in;
  final String? check_out;
  final DateTime createdAt;
  final Map? checkInLocation;
  final Map? checkOutLocation;
  AttendanceModel({required this.id,
    required this.date,
    required this.check_in ,
    this.check_out,
    this.checkInLocation,
    this.checkOutLocation,
    required this.createdAt});

  factory AttendanceModel.fromJson(Map<String,dynamic> data){
    return AttendanceModel(
        id: data['employee_id'],
        date: data['date'],
        check_in: data['check_in'],
        check_out: data['check_out'],
        createdAt: DateTime.parse(data['created_at'],),
        checkInLocation : data['check_in_location'],
        checkOutLocation: data['check_out_location']
    );
  }
}