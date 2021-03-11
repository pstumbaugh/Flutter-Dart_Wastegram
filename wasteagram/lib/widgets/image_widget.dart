import '../imports.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  ImageWidget({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Image.network('$imagePath'));
  }
}
