import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:seller/app_constants.dart';
import 'package:seller/spinners.dart';

import '../theme/constant.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Map<dynamic, dynamic> profileData;
  late OutlineInputBorder outlineInputBorder;
  double profileRadius = 200;
  bool isProfileDataLoaded = false;
  var nameController = TextEditingController(),
      mobileController = TextEditingController();
  var cityController = TextEditingController();
  var bioController = TextEditingController();

  TextEditingController stateController = TextEditingController(),
      countryController = TextEditingController(),
      pinCodeController = TextEditingController();

  XFile? img;
  File? imgPath;

  int? _radioValue = 1;

  @override
  void initState() {
    super.initState();
    initProfile();
    outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding:
            FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
        child: Column(
          children: [
            titleRow(),
            (isProfileDataLoaded)
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: profileRadius,
                                height: profileRadius,
                                decoration: BoxDecoration(
                                  image: (imgPath != null)
                                      ? DecorationImage(
                                          image: FileImage(imgPath!),
                                          fit: BoxFit.fill,
                                        )
                                      : DecorationImage(
                                          image: NetworkImage(
                                              profileData['profile_pic']),
                                          fit: BoxFit.fill,
                                        ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 20,
                                child: InkWell(
                                  onTap: () {
                                    showImagePickOptions();
                                  },
                                  child: const Icon(
                                    Icons.camera_enhance_rounded,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FxSpacing.height(10),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: FxSpacing.fromLTRB(0, 0, 0, 12),
                          child: FxText.titleMedium(
                            "Personal",
                            fontWeight: 600,
                          ),
                        ),
                        getTextField("Full Name", Icons.account_circle_outlined,
                            nameController,
                            maxLength: 40),
                        FxSpacing.height(10),
                        getTextField("Mobile", Icons.call, mobileController,
                            maxLength: 10, keyboardType: TextInputType.number),
                        FxSpacing.height(10),
                        Row(
                          children: [
                            FxText.bodyLarge("Gender", fontWeight: 600),
                            Container(
                              margin: FxSpacing.left(8),
                              child: Radio(
                                value: 1,
                                activeColor: theme.colorScheme.primary,
                                groupValue: _radioValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    _radioValue = value;
                                  });
                                },
                              ),
                            ),
                            FxText.titleSmall(
                              "Male",
                              color:
                                  theme.colorScheme.onBackground.withAlpha(240),
                              letterSpacing: 0.2,
                              fontWeight: 500,
                            ),
                            Container(
                              margin: FxSpacing.left(8),
                              child: Radio(
                                value: 2,
                                activeColor: theme.colorScheme.primary,
                                groupValue: _radioValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    _radioValue = value;
                                  });
                                },
                              ),
                            ),
                            FxText.titleSmall(
                              "Female",
                              color:
                                  theme.colorScheme.onBackground.withAlpha(240),
                              letterSpacing: 0.2,
                              fontWeight: 500,
                            ),
                            Container(
                              margin: FxSpacing.left(8),
                              child: Radio(
                                value: 3,
                                activeColor: theme.colorScheme.primary,
                                groupValue: _radioValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    _radioValue = value;
                                  });
                                },
                              ),
                            ),
                            FxText.titleSmall(
                              "Other",
                              color:
                                  theme.colorScheme.onBackground.withAlpha(240),
                              letterSpacing: 0.2,
                              fontWeight: 500,
                            ),
                          ],
                        ),
                        FxSpacing.height(10),
                        getTextField(
                            "About yourself", Icons.edit, bioController),
                        FxSpacing.height(10),
                        getTextField(
                            "City", Icons.location_city_sharp, cityController,
                            maxLength: 40),
                        FxSpacing.height(10),
                        getTextField("State", Icons.map, stateController,
                            maxLength: 25),
                        FxSpacing.height(10),
                        getTextField("Country", Icons.flag, countryController,
                            maxLength: 40),
                        FxSpacing.height(10),
                        getTextField("Pin code", Icons.pin_drop_outlined,
                            pinCodeController,
                            keyboardType: TextInputType.number, maxLength: 6),
                        FxSpacing.height(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FxButton.medium(
                              backgroundColor: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                  ),
                                  FxSpacing.width(3),
                                  const Text(
                                    "Discard",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FxButton.medium(
                              backgroundColor: Colors.green,
                              onPressed: () {
                                updateProfileInfo();
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.upload_outlined,
                                    color: Colors.white,
                                  ),
                                  FxSpacing.width(3),
                                  const Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        FxSpacing.height(60),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(top: 70),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SpinKitWaveSpinner(
                            color: Colors.deepPurpleAccent,
                            waveColor: Constant.softColors.violet.color,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.chevron_left),
            ),
            FxSpacing.width(8),
            FxContainer(
              width: 10,
              height: 24,
              color: theme.colorScheme.primaryContainer,
              borderRadiusAll: 2,
            ),
            FxSpacing.width(8),
            FxText.titleMedium(
              "Edit Profile",
              fontWeight: 600,
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                updateProfileInfo();
              },
              child: Icon(Icons.check),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> loadFromLocal() async {
    AndroidOptions a() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    var s = FlutterSecureStorage(aOptions: a());
    final res = await s.read(key: 'user_data');
    if (res != null) {
      if (mounted) {
        setState(() {
          profileData = jsonDecode(res);
          nameController.text = profileData['name'];
          mobileController.text = profileData['mobile'];
          cityController.text = profileData['city'];
          bioController.text = profileData['bio'];
          stateController.text = profileData['state'];
          countryController.text = profileData['country'];
          pinCodeController.text = profileData['pincode'];
          if (profileData.containsKey("gender")) {
            switch (profileData['gender'].toString().toUpperCase()) {
              case 'M':
                _radioValue = 1;
                break;
              case 'F':
                _radioValue = 2;
                break;
              default:
                _radioValue = 3;
            }
          }
          isProfileDataLoaded = true;
        });
      }
    }
  }

  Future<void> initProfile() async {
    loadFromLocal();
  }

  Widget getTextField(
      String hintText, IconData icon, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLength = 200}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: hintText,
        border: theme.inputDecorationTheme.border,
        enabledBorder: theme.inputDecorationTheme.border,
        focusedBorder: theme.inputDecorationTheme.focusedBorder,
        prefixIcon: Icon(icon, size: 24),
      ),
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (v) {},
    );
  }

  Future showImagePickOptions() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text("Gallery"),
                  ),
                ),
                FxSpacing.height(5),
                InkWell(
                  onTap: () {
                    pickImage(ImageSource.camera);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text("Camera"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future pickImage(ImageSource src) async {
    try {
      final image = await ImagePicker().pickImage(source: src);
      if (image == null) return;
      img = image;
      final path = File(image.path);
      setState(() {
        imgPath = path;
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      Spinners spn = Spinners(context: context);
      spn.showAlert("Error",
          "Image access denied.\nPlease allow storage and gallery access from settings", CoolAlertType.error);
    }
  }

  Future<void> updateProfileInfo() async {
    Spinners spn = Spinners(context: context);
    spn.showSpinner();

    var formData = http.MultipartRequest("POST", Uri.parse(baseUrl));
    if (img != null) {
      formData.files
          .add(await http.MultipartFile.fromPath("new_profile", img!.path));
    }

    // formData.fields['APP_ID'] = appId;

    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    final existingSessionId = await storage.read(key: "SESSION_ID");
    // if (existingSessionId != null) {
    //   formData.fields['SESSION_ID'] = existingSessionId;
    // }

    formData.headers['session_id'] = (existingSessionId != null) ? existingSessionId : '';
    formData.headers['app_id'] = appId.toString();

    formData.fields['module'] = "vendor";
    formData.fields['submodule'] = "update";

    formData.fields['name'] = nameController.text;
    formData.fields['mobile'] = mobileController.text;
    formData.fields['bio'] = bioController.text;
    formData.fields['city'] = cityController.text;
    formData.fields['state'] = stateController.text;
    formData.fields['country'] = countryController.text;
    formData.fields['pincode'] = pinCodeController.text;
    formData.fields['gender'] = _radioValue.toString();

    var ct = context;
    final response = await formData.send();

    try {
      final strData = await response.stream.toBytes();
      var strJson = String.fromCharCodes(strData);
      // print(strJson);
      var jsonObj = jsonDecode(strJson.toString());
      // print(jsonObj);
      if (jsonObj != null) {
        if (jsonObj['status'] == 200) {
          AndroidOptions a() =>
              const AndroidOptions(encryptedSharedPreferences: true);
          final st = FlutterSecureStorage(aOptions: a());
          await st.write(key: "user_data", value: jsonEncode(jsonObj['data']));
          if (mounted) {
            spn.showAlert("Information Updated",
                "Profile information has been updated Successfully.", CoolAlertType.success);
          }
        } else {
          spn.showAlert("Error", "Something went wrong", CoolAlertType.error);
        }
      }
    } catch (e) {
      spn.showAlert("Error", e.toString(), CoolAlertType.error);
      print(e);
    }
    spn.hideSpinner();
  }
}
