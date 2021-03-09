class FormFields {
  String date;
  String image;
  int total;
  double longitude;
  double latitude;

  FormFields(
      {this.date, this.image, this.total, this.longitude, this.latitude});

  int get wasteTotal {
    return total;
  }
}
