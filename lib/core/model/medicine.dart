class Medicine {
  final int? id;
  final String name;
  final String time;
  final int intervalHours;
  final String userName;

  Medicine({
    this.id,
    required this.name,
    required this.time,
    required this.intervalHours,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'intervalHours': intervalHours,
      'userName': userName,
    };
  }

  static Medicine fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      time: map['time'],
      intervalHours: map['intervalHours'],
      userName: map['userName'],
    );
  }
}
