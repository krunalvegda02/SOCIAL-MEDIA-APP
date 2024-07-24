import 'package:image_picker/image_picker.dart';
import 'package:sm/utils/toastMessage.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imgPicker = ImagePicker();

  XFile? _file = await _imgPicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  Utils.toastmessage("No Image found");
}
