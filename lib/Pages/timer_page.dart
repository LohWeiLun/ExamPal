
import 'dart:async';
import 'package:flutter/material.dart';
import '../Widgets/button_widget.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>{
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

  void resetTimer() => setState(() => seconds = maxSeconds);

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if(seconds > 0){
        setState(() => seconds--);
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if(reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTime(),
              const SizedBox(height: 80),
              buildButtons(),
            ],
          )
      ),
    ),
  );

  Widget buildButtons(){
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
          text: isRunning ? 'Pause' : 'Resume',
          onClicked: () {
            if (isRunning) {
              stopTimer(reset: false);
            } else {
              startTimer(reset: false);
            }
          },
        ),
        const SizedBox(width: 12),
        ButtonWidget(
          text: 'Cancel',
          onClicked: stopTimer,
        ),
      ],
    )
        : ButtonWidget(
      text: 'Start Studying!',
      color: Colors.black,
      backgroundColor: Colors.white,
      onClicked: () {
        startTimer();
      },
    );
  }

  Widget buildTimer() => SizedBox(
    width:200,
    height: 200,
    child: Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: seconds / maxSeconds,
          valueColor: const AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 12,
          backgroundColor: Colors.greenAccent,
        ),
        Center(child: buildTime()),
      ],
    ),
  );

  Widget buildTime() {
    if(seconds == 0) {
      return const Icon(Icons.done, color: Colors.greenAccent, size: 112);
    } else {
      return Text(
        '$seconds',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 80,
        ),
      );
    }

  }

}



