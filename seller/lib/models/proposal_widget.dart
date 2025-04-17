import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutx/flutx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:seller/theme/constant.dart';

import '../app_constants.dart';

class Proposal {
  final String title, filename, filepath, description, image, productTitle;
  Proposal(this.title, this.description, this.image, this.filename,
      this.filepath, this.productTitle);

  static Proposal getProposalFromJson(dynamic data) {
    return Proposal(
        data['title'].toString(),
        data['description'].toString(),
        data['banner_url'].toString(),
        data['filename'].toString(),
        data['file_url'].toString(),
        data['badge_title']);
  }

  static List<Proposal> getProposalListFromJson(dynamic data) {
    List<Proposal> ans = [];
    for (var row in data) {
      ans.add(getProposalFromJson(row));
    }
    return ans;
  }
}

class ProposalWidget extends StatefulWidget {
  final Proposal proposal;

  const ProposalWidget(this.proposal, {super.key});

  @override
  State<ProposalWidget> createState() => _ProposalWidgetState();
}

class _ProposalWidgetState extends State<ProposalWidget> {
  late final String title, filename, filepath, description, image;
  bool isDownloadStatusFetched = false;
  late bool isDownloaded;
  bool downloading = false;
  double downloadProgress = 0.01;
  late File fileObject;

  @override
  void initState() {
    super.initState();
    title = widget.proposal.title;
    filename = widget.proposal.filename;
    filepath = widget.proposal.filepath;
    description = widget.proposal.description;
    image = widget.proposal.image;
    checkIfDownloaded();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = 250;
    double maxHeight = 330;

    return Stack(
      children: [
        FxContainer(
          width: maxWidth,
          margin: const EdgeInsets.only(right: 10),
          height: maxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInImage.assetNetwork(
                    image: image,
                    placeholder: placeholderImage,
                    fit: BoxFit.cover,
                    height: 140,
                    width: 220,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                      placeholderImage,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  FxSpacing.height(15),
                  FxText.bodySmall(
                    (title.length > 60)
                        ? "${title.substring(0, 57)}..."
                        : title,
                    fontWeight: 600,
                  ),
                  FxSpacing.height(5),
                  FxText.bodySmall(
                    (description.length > 110)
                        ? "${description.substring(0, 107)}..."
                        : description,
                    fontWeight: 600,
                    xMuted: true,
                  ),
                ],
              ),
              FxSpacing.height(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (downloading)
                      ? CircularProgressIndicator(
                          value: downloadProgress,
                          backgroundColor: Constant.softColors.violet.color,
                          color: Constant.softColors.violet.onColor,
                        )
                      : SizedBox.shrink(),
                  PopupMenuButton(
                    itemBuilder: (context) => actionButtons(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 15,
          top: 7,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Constant.softColors.violet.color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Constant.softColors.violet.color,
              ),
            ),
            child: Text(
              widget.proposal.productTitle,
              style: TextStyle(
                fontSize: 10,
                color: Constant.softColors.violet.onColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> checkIfDownloaded() async {
    final Directory? directory = await getExternalStorageDirectory();

    final String newPath = '${directory?.path}/$filename';

    File file = File(newPath);
    if (await file.exists()) {
      fileObject = file;
      isDownloaded = true;
    } else {
      isDownloaded = false;
    }

    setState(() {
      isDownloadStatusFetched = true;
    });
  }

  List<PopupMenuItem> actionButtons() {
    double iconSize = 18;

    List<PopupMenuItem> ans = [];

    if (isDownloadStatusFetched && isDownloaded == false) {
      ans.add(
        PopupMenuItem(
          onTap: () {
            _downloadFile();
          },
          child: (isDownloadStatusFetched && isDownloaded)
              ? Icon(
                  Icons.download_done_rounded,
                  size: 18,
                )
              : Row(
                  children: [
                    Icon(
                      Icons.download,
                      size: 18 + 4,
                      color: Colors.blue,
                    ),
                    FxSpacing.width(10),
                    FxText.titleSmall(
                      "Download Proposal",
                    ),
                  ],
                ),
        ),
      );
    }

    ans.addAll(
      [
        PopupMenuItem(
          onTap: () async {
            await _downloadMessage();
            await _openFile();
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.eye,
                color: Colors.black.withOpacity(0.7),
                size: iconSize + 3,
              ),
              FxSpacing.width(10),
              FxText.titleSmall(
                "View Proposal",
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            await _downloadMessage();
            await _shareOnWhatsApp();
          },
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.whatsapp,
                size: iconSize,
                color: Colors.green,
              ),
              FxSpacing.width(10),
              FxText.titleSmall(
                "Share on Whatsapp",
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () async {
            await _downloadMessage();
            await Share.shareXFiles([XFile(fileObject.path)], text: title);
          },
          child: Row(
            children: [
              Icon(
                Icons.share,
                size: iconSize,
                color: Constant.softColors.blue.onColor,
              ),
              FxSpacing.width(10),
              FxText.titleSmall(
                "Share via other apps",
              ),
            ],
          ),
        ),
      ],
    );

    return ans;
  }

  // private functions

  Future<void> _downloadFile() async {
    String url = filepath;
    String fileName = filename;

    final perm = await _checkPermissionForLocalStorage();
    if (!perm) {
      if (mounted) {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text:
                "Can not download file because storage permission denied. Please enable it from settings.",
            title: "Permission Denied",
            onConfirmBtnTap: () async {
              await openAppSettings();
            },
            confirmBtnText: "Open Settings",
            showCancelBtn: true);
      }
      return;
    }

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';

    final Dio dio = Dio();
    await dio.download(url, filePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        setState(() {
          downloading = true;
          downloadProgress = (1.0 * received / total);
        });
      }
    });

    fileObject = _createFileObject(filePath);
    await _saveFileToLocal(fileObject, fileName);

    if (mounted) {
      setState(() {
        isDownloaded = true;
        downloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 20),
        content: const Text(
          "Proposal has been downloaded, you can now share it anywhere you want",
        ),
        action: SnackBarAction(
          label: "Ok",
          onPressed: () {},
        ),
      ));
    }
    checkIfDownloaded();
  }

  Future<void> _saveFileToLocal(File file, String newFileName) async {
    final perm = await _checkPermissionForLocalStorage();
    if (!perm) {
      return;
    }

    final Directory? directory = await getExternalStorageDirectory();

    final String newPath = '${directory?.path}/$newFileName';

    final newFile = await file.copy(newPath);

    if (await newFile.exists()) {
      fileObject = newFile;
    }
  }

  File _createFileObject(String path) {
    return File.fromUri(Uri.parse(path));
  }

  Future<bool> _checkPermissionForLocalStorage() async {
    if (await Permission.manageExternalStorage.isGranted) return true;

    final PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      final res = await Permission.storage.request();

      if (res.isPermanentlyDenied) {
        return (await Permission.storage.status).isGranted;
      }

      if (res.isGranted) return true;

      await Permission.manageExternalStorage.request();
      return false;
    }
    return true;
  }

  Future<void> _openFile() async {
    if (!isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Proposal is not downloaded yet !!",
        ),
        duration: Duration(seconds: 5),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Opening proposal...",
        ),
        duration: Duration(seconds: 5),
      ),
    );
    await OpenFile.open(fileObject.path);
  }

  Future<void> _shareOnWhatsApp() async {
    // await WhatsappShare.shareFile(
    //   phone: '+91000000000',
    //   filePath: [fileObject.path],
    //   text: "Type your Message here",
    // );
  }

  Future<void> _downloadMessage() async {
    if (!isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Please wait, proposal is downloading..."),
        duration: const Duration(seconds: 20),
        action: SnackBarAction(
          label: "Ok",
          onPressed: () {},
        ),
      ));
      await _downloadFile();
    }
  }
}
