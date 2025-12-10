import 'department.dart';

class Employee {
  final String userId;
  final String name;
  final Department department;

  Employee({
    required this.userId,
    required this.name,
    required this.department,
  });
}
