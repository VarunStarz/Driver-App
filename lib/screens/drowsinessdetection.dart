import 'package:camera/camera.dart';
import 'package:driverapp/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
//import 'package:tflite_flutter/tflite_flutter.dart';

class drowsinessDetectionPage extends StatefulWidget {
  const drowsinessDetectionPage({Key? key}) : super(key: key);

  @override
  _drowsinessDetectionPageState createState() =>
      _drowsinessDetectionPageState();
}

class _drowsinessDetectionPageState extends State<drowsinessDetectionPage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted)
        return;
      else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);

      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
          if (output == '1') {
            score++;
          } else
            score--;
        });
      });
    }
    if (score >= 10) output = '1';
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/images/drowsiness_model.tflite",
        labels: "assets/images/labels.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live detection"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: !cameraController!.value.isInitialized
                  ? Container()
                  : AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
            ),
          ),
          Text(
            output,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          )
        ],
      ),
    );
  }
}
