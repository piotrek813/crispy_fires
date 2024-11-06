import 'dart:io';

import 'package:crispy_fires/client/client.dart';
import 'package:crispy_fires/colors.dart';
import 'package:crispy_fires/database/database.dart';
import 'package:crispy_fires/lobby/lobby_provider.dart';
import 'package:crispy_fires/server/server.dart';
import 'package:crispy_fires/table/table_screen.dart';
import 'package:crispy_fires/widgets/button.dart';
import 'package:crispy_fires/widgets/player_photo.dart';
import 'package:crispy_fires/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences)
  ], child: const MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark, seedColor: CrispyColors.background),
        useMaterial3: true,
        scaffoldBackgroundColor: CrispyColors.background,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final sharedPrefs = ref.read(sharedPreferencesProvider);
          if (sharedPrefs.getString("name") == null) {
            return const UserSettings();
          }

          return const HomeScreen();
        },
      ),
    );
  }
}

@Riverpod(dependencies: [])
String name(Ref ref) {
  return ref.watch(sharedPreferencesProvider).getString("name")!;
}

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final controller = TextEditingController();
  final form = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(child: PlayerPhoto(radius: 40, name: controller.text)),
              const SizedBox(
                height: 34,
              ),
              CrispyTextField(
                controller: controller,
                label: "Twoje imię",
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nie masz imienia?";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 14,
              ),
              Consumer(
                builder: (context, ref, child) {
                  return CrispyButton(
                    onPressed: () async {
                      if (!form.currentState!.validate()) {
                        return;
                      }

                      await ref
                          .read(sharedPreferencesProvider)
                          .setString("name", controller.text);

                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()));
                      }
                    },
                    label: "Dalej",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

@Riverpod(dependencies: [])
bool isHost(Ref ref) {
  return false;
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(35.0),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/cover.png"),
                    const Text("Crispy Chips Casino",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 44, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 34,
                    ),
                    CrispyButton(
                      background: CrispyColors.blue,
                      label: "Dołącz do gry",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const JoinTable()));
                      },
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    CrispyButton(
                      label: "Nowa gra",
                      onPressed: () {
                        ref.read(serverProvider).start();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProviderScope(overrides: [
                                      isHostProvider.overrideWithValue(true)
                                    ], child: const LobbyScreen())));
                      },
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    const CrispyButton(
                      label: "Kontynuuj",
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class JoinTable extends StatefulWidget {
  const JoinTable({super.key});

  @override
  State<JoinTable> createState() => _JoinTableState();
}

class _JoinTableState extends State<JoinTable> {
  final controller = TextEditingController(text: "192.168.55.102");
  final form = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 50,
              ),
              CrispyTextField(
                controller: controller,
                label: "IP hosta",
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "IP to poproszę";
                  }

                  final ipParts = value.split(".");
                  if (ipParts.length != 4 || ipParts.any((e) => e.length > 3)) {
                    return "No to napewno nie jest IP";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 14,
              ),
              Consumer(
                builder: (context, ref, child) {
                  return CrispyButton(
                    onPressed: () async {
                      if (!form.currentState!.validate()) {
                        return;
                      }

                      await ref.read(clientProvider).connect(controller.text);

                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LobbyScreen())).then((_) {
                          ref.read(clientProvider).socket.close();
                        });
                      }
                    },
                    label: "Dalej",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

@riverpod
Future<String> ipAddress(Ref ref) async {
  final ips = await NetworkInterface.list(type: InternetAddressType.IPv4);
  return ips.first.addresses.first.address;
}

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHost = ref.watch(isHostProvider);
    final name = ref.watch(nameProvider);
    final lobbyUsers = ref.watch(lobbyProvider);

    final isAccepted = lobbyUsers.any((e) => e.name == name && e.isAccepted);

    if (!isAccepted) {
      return PopScope(
        onPopInvokedWithResult: (_, __) {
          ref.invalidate(lobbyProvider);
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ciekawe czy ciebie wpuszczą?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 20,
                ),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            if (isHost)
              Text(ref.watch(ipAddressProvider).valueOrNull ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge)
            else
              Text("A teraz czekamy, aż wszyscy dołączą",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: ListView(
                children: lobbyUsers
                    .map((e) => ListTile(
                          leading: PlayerPhoto(name: e.name),
                          title: Text(e.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isHost && !e.isAccepted)
                                CrispyButton(
                                  onPressed: () => ref
                                      .read(lobbyProvider.notifier)
                                      .accept(e.name),
                                  background: CrispyColors.green,
                                  icon: const Icon(Icons.check),
                                ),
                              const SizedBox(
                                width: 4,
                              ),
                              if (isHost && e.name != name)
                                CrispyButton(
                                  onPressed: () => ref
                                      .read(lobbyProvider.notifier)
                                      .decline(e.name),
                                  background: CrispyColors.red,
                                  icon: const Icon(Icons.close),
                                ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            if (isHost)
              CrispyButton(
                isDisabled: ref
                        .watch(lobbyProvider)
                        .where((e) => e.isAccepted)
                        .length <=
                    1,
                label: "Zaczynamy",
                onPressed: () {
                  ref.read(serverProvider).sendGameStart();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProviderScope(overrides: [
                                isHostProvider.overrideWithValue(true)
                              ], child: const TableScreen())));
                },
              ),
          ],
        ),
      ),
    );
  }
}
