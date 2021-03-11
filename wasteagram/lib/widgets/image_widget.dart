import '../imports.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  ImageWidget({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 350.0,
        height: 500.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
                image: NetworkImage('$imagePath'), fit: BoxFit.scaleDown)));
  }
}
