import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

void main() {
  runApp(InviteApp());
}

String placeA = "";
DateTime dateA = DateTime.now();
TimeOfDay timeA = TimeOfDay.now(); // Variável para armazenar a hora

class InviteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      theme: ThemeData(
        primarySwatch: Colors.pink, // Tema romântico
      ),
      home: InviteHomePage(),
    );
  }
}

class InviteHomePage extends StatefulWidget {
  @override
  _InviteHomePageState createState() => _InviteHomePageState();
}

Future<void> launchWhatsApp(context) async {
  final String inviteMessage =
      "Nosso encontro está marcado!!!\n Vamos sair para... \n\nLocal: $placeA\nData: ${dateA.toLocal().toString().split(' ')[0]} \nHorário: ${timeA.format(context)}? 😄"; // Inclui o horário
  final String phone = "31989183607";
  String phoneNumber = "https://wa.me/55$phone?text=";

  final link = WhatsAppUnilink(
    phoneNumber: phoneNumber,
    text: inviteMessage,
  );
  await launchUrlString('$link', mode: LaunchMode.externalApplication);
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Erro'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    ),
  );
}

class _InviteHomePageState extends State<InviteHomePage> {
  final String girlName = 'Ana'; // Nome dela
  final String photoPath = 'assets/images/ana.jpg'; // Foto dela
  final List<String> places = [
    'Bar',
    'Restaurante',
    'Museu',
    'Cinema',
  ];
  final Map<String, IconData> icons = {
    'Bar': Icons.local_bar,
    'Restaurante': Icons.restaurant,
    'Museu': Icons.house,
    'Cinema': Icons.movie,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Convite Especial ❤️',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Exibindo a foto dela com efeito suave
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(photoPath),
              child: const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.favorite, color: Colors.redAccent, size: 30),
              ),
            ),
            const SizedBox(height: 20),
            // Mensagem animada com efeito de digitação
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Eii $girlName, você está convidada para um encontro especial!',
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
            ),
            const SizedBox(height: 20),
            // Opções de lugares com ícones
            const Text(
              'Escolha o local:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        icons[places[index]],
                        color: places[index].toLowerCase().contains("bar")
                            ? Colors.green
                            : Colors.pinkAccent,
                      ),
                      title: Text(places[index],
                          style: const TextStyle(fontSize: 18)),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          placeA = places[index];
                          dateA = selectedDate ?? DateTime.now();
                          if (selectedDate != null) {
                            // Após escolher a data, pede para escolher o horário
                            showTimePicker(
                              context: context,
                              initialTime: timeA,
                            ).then((selectedTime) {
                              timeA = selectedTime ?? TimeOfDay.now();
                              if (selectedTime != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SuccessScreen(
                                      place: places[index],
                                      date: selectedDate,
                                      time: selectedTime,
                                    ),
                                  ),
                                );
                              }
                            });
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de sucesso após marcar o encontro
class SuccessScreen extends StatelessWidget {
  SuccessScreen({required this.place, required this.date, required this.time});

  final String place;
  final DateTime date;
  final TimeOfDay time; // Hora marcada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle, // Ícone de sucesso
              color: Colors.green, // Cor do ícone
              size: 100, // Tamanho do ícone
            ),
            const SizedBox(height: 20),
            const Text(
              'Encontro marcado!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent),
            ),
            const SizedBox(height: 10),
            Text(
              'Local: $place',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            Text(
              'Data: ${date.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            Text(
              'Horário: ${time.format(context)}',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                launchWhatsApp(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Enviar p/ Bia'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Voltar ao convite'),
            ),
          ],
        ),
      ),
    );
  }
}
