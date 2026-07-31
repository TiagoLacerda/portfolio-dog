import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../../l10n/generated/modular_localization.dart';

class SoundButton extends StatefulWidget {
  const SoundButton({super.key});

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  final soloud = SoLoud.instance;

  AudioSource? source;
  SoundHandle? handle;

  bool get playing => handle == null ? false : !soloud.getPause(handle!);

  Future<void> initialize() async {
    AudioSource? source;
    SoundHandle? handle;

    try {
      // TODO: This initialization should be done once in the app lifecycle, and therefore doesn't belong here.
      await soloud.init();

      source = await soloud.loadAsset('sounds/afternoon_break.mp3');
      handle = await soloud.play(source, looping: true, paused: true);

      setState(() {
        this.source = source;
        this.handle = handle;
      });
    } catch (e) {
      log(e.toString());

      if (source != null) {
        soloud.disposeSource(source);
      }

      setState(() {
        this.source = null;
        this.handle = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    if (source != null) {
      soloud.disposeSource(source!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!soloud.isInitialized) return;
        setState(() => soloud.setPause(handle!, playing));
      },
      tooltip: ModularLocalization.localizations.modules.home.widgets.soundButton.toggleMusic,
      style: IconButton.styleFrom(
        backgroundColor: ColorScheme.of(context).primary,
        foregroundColor: ColorScheme.of(context).surface,
      ),
      icon: Icon(
        playing ? Icons.music_note_outlined : Icons.music_off_outlined,
      ),
    );
  }
}
