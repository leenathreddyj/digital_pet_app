//Venkata Saileenath Reddy Jampala
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  DigitalPetAppState createState() => DigitalPetAppState();
}

class DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;
  Timer? hungerTimer;
  final TextEditingController _nameController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _backgroundImage = "assets/default_background.jpg";

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    _nameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startHungerTimer() {
    hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        if (hungerLevel >= 100 && happinessLevel <= 10) {
          _showGameOverDialog();
        }
      });
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
      _backgroundImage = "assets/kid_playing_with_dog.gif";
    });
    _audioPlayer.play(AssetSource("audio/dog_happy.mp3"));
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel + 10).clamp(0, 100);
      _backgroundImage = "assets/feeding_dog.gif";
    });
    _audioPlayer.play(AssetSource("audio/dog_eating.mp3"));
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: const Text("Your pet is too hungry and unhappy!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Color _getPetColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  String _getPetMood() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
  }

  void _setPetName() {
    setState(() {
      petName = _nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Pet')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Name: $petName', style: const TextStyle(fontSize: 20.0)),
              const SizedBox(height: 16.0),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getPetColor(),
                ),
                child: Center(
                  child: Text(
                    _getPetMood(),
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Happiness Level: $happinessLevel',
                  style: const TextStyle(fontSize: 20.0)),
              Text('Hunger Level: $hungerLevel',
                  style: const TextStyle(fontSize: 20.0)),
              Text('Energy Level: $energyLevel',
                  style: const TextStyle(fontSize: 20.0)),
              const SizedBox(height: 16.0),
              LinearProgressIndicator(value: energyLevel / 100),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: _playWithPet,
                  child: const Text('Play with Your Pet')),
              ElevatedButton(
                  onPressed: _feedPet, child: const Text('Feed Your Pet')),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Enter Pet Name"),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _setPetName,
                child: const Text("Confirm Name"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
