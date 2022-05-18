import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

//colors
const mainC = Color(0xff000000);
const mainCAlt = Color(0xff141414);
const secondaryC = Color(0xffABB6BF);
const secondaryCdark = Color(0xff727070);
const secondaryCAlt = Color(0xff020303);
const actionC = Color(0xffFCA311);
const actionCDark = Color(0xff8D5801);

//loading animation
final Widget loadingAnim = Lottie.asset('assets/LoadingLottie.json');

//network images
const defaultProfilePic =
    'https://3.bp.blogspot.com/-UI5bnoLTRAE/VuU18_s6bRI/AAAAAAAADGA/uafLtb4ICCEK8iO3NOh1C_Clh86GajUkw/s1600/guest.png';

//Icon
const bunHubLogoSVG = 'assets/Images/bunhub_logo1.svg';
final Widget bunHubLogo = SvgPicture.asset(
  bunHubLogoSVG,
);

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
