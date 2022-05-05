class Student {
  String name;
  String sNummer;
  Student({required this.name, required this.sNummer});
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      sNummer: json['sNummer'],
    );
  }
}
