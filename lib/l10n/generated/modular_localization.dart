import 'modular_localization_delegate.dart';
import 'modular_localization_entries.dart';
import 'modular_localization_entries_en.dart';

abstract class ModularLocalization {
  const ModularLocalization();

  static ModularLocalizationEntries entries = const ModularLocalizationEntriesEn();

  /// modular_localization's `LocalizationsDelegate`.
  static const delegate = ModularLocalizationDelegate();

  /// Localized resources.
  static const ModularLocalizationInternalClass0 localizations =
      ModularLocalizationInternalClass0();
}

class ModularLocalizationInternalClass0 implements ModularLocalization {
  const ModularLocalizationInternalClass0();

  /// **.home**: `...`
  ///
  ModularLocalizationInternalClass1 get modules => const ModularLocalizationInternalClass1();
}

class ModularLocalizationInternalClass1 implements ModularLocalization {
  const ModularLocalizationInternalClass1();

  /// **.homeView**: `...`
  ///
  /// **.widgets**: `...`
  ///
  ModularLocalizationInternalClass2 get home => const ModularLocalizationInternalClass2();
}

class ModularLocalizationInternalClass2 implements ModularLocalization {
  const ModularLocalizationInternalClass2();

  /// **.brightnessSwitchTooltip**
  ///
  /// `en`: **"Dark/light mode"**
  ///
  /// `pt`: **"Modo claro/escuro"**
  ///
  /// **.homeButtonTooltip**
  ///
  /// `en`: **"Homepage"**
  ///
  /// `pt`: **"Página inicial"**
  ///
  /// **.localeButtonTooltip**
  ///
  /// `en`: **"Language"**
  ///
  /// `pt`: **"Idioma"**
  ///
  /// **.text0**
  ///
  /// `en`: **"The "**
  ///
  /// `pt`: **"A "**
  ///
  /// **.text1**
  ///
  /// `en`: **"Flow-Based Difference of Gaussians (FDoG)"**
  ///
  /// `pt`: **"Diferença de Gaussianas Baseada em Fluxo (FDoG)"**
  ///
  /// **.text2**
  ///
  /// `en`: **" is an image processing technique that enables a wide range of stylizations, like "**
  ///
  /// `pt`: **" é uma técnica de processamento de imagens que possibilita uma ampla variedade de estilizações, como efeitos de "**
  ///
  /// **.text3**
  ///
  /// `en`: **" effects."**
  ///
  /// `pt`: **"."**
  ///
  /// **.text4**
  ///
  /// `en`: **"\n\nProposed by "**
  ///
  /// `pt`: **"\n\nProposta por "**
  ///
  /// **.text5**
  ///
  /// `en`: **"Holger Winnemöller and his team"**
  ///
  /// `pt`: **"Holger Winnemöller e sua equipe"**
  ///
  /// **.text6**
  ///
  /// `en`: **", it extends the traditional Difference of Gaussians (DoG) by approximating the structure tensor of the image using the Sobel operator, then guiding the filtering process so that blurring and edge enhancement occur along the natural flow of the image's features."**
  ///
  /// `pt`: **", ela amplia a técnica tradicional de Diferença de Gaussianas (DoG) ao aproximar o tensor de estrutura da imagem usando o operador de Sobel e, em seguida, orientar o processo de filtragem para que o desfoque e o realce de bordas ocorram ao longo do fluxo natural das características da imagem."**
  ///
  /// **.effects**: `...`
  ///
  ModularLocalizationInternalClass3 get homeView => const ModularLocalizationInternalClass3();
  /// **.fdogShaderControls**: `...`
  ///
  /// **.paletteGenerateDialog**: `...`
  ///
  /// **.paletteImportDialog**: `...`
  ///
  /// **.soundButton**: `...`
  ///
  ModularLocalizationInternalClass5 get widgets => const ModularLocalizationInternalClass5();
}

class ModularLocalizationInternalClass3 implements ModularLocalization {
  const ModularLocalizationInternalClass3();

  /// `en`: **"Dark/light mode"**
  ///
  /// `pt`: **"Modo claro/escuro"**
  ///
  String get brightnessSwitchTooltip => ModularLocalization.entries.entry0;

  /// `en`: **"Homepage"**
  ///
  /// `pt`: **"Página inicial"**
  ///
  String get homeButtonTooltip => ModularLocalization.entries.entry1;

  /// `en`: **"Language"**
  ///
  /// `pt`: **"Idioma"**
  ///
  String get localeButtonTooltip => ModularLocalization.entries.entry2;

  /// `en`: **"The "**
  ///
  /// `pt`: **"A "**
  ///
  String get text0 => ModularLocalization.entries.entry3;

  /// `en`: **"Flow-Based Difference of Gaussians (FDoG)"**
  ///
  /// `pt`: **"Diferença de Gaussianas Baseada em Fluxo (FDoG)"**
  ///
  String get text1 => ModularLocalization.entries.entry4;

  /// `en`: **" is an image processing technique that enables a wide range of stylizations, like "**
  ///
  /// `pt`: **" é uma técnica de processamento de imagens que possibilita uma ampla variedade de estilizações, como efeitos de "**
  ///
  String get text2 => ModularLocalization.entries.entry5;

  /// `en`: **" effects."**
  ///
  /// `pt`: **"."**
  ///
  String get text3 => ModularLocalization.entries.entry6;

  /// `en`: **"\n\nProposed by "**
  ///
  /// `pt`: **"\n\nProposta por "**
  ///
  String get text4 => ModularLocalization.entries.entry7;

  /// `en`: **"Holger Winnemöller and his team"**
  ///
  /// `pt`: **"Holger Winnemöller e sua equipe"**
  ///
  String get text5 => ModularLocalization.entries.entry8;

  /// `en`: **", it extends the traditional Difference of Gaussians (DoG) by approximating the structure tensor of the image using the Sobel operator, then guiding the filtering process so that blurring and edge enhancement occur along the natural flow of the image's features."**
  ///
  /// `pt`: **", ela amplia a técnica tradicional de Diferença de Gaussianas (DoG) ao aproximar o tensor de estrutura da imagem usando o operador de Sobel e, em seguida, orientar o processo de filtragem para que o desfoque e o realce de bordas ocorram ao longo do fluxo natural das características da imagem."**
  ///
  String get text6 => ModularLocalization.entries.entry9;

  /// **.charcoal**
  ///
  /// `en`: **"charcoal"**
  ///
  /// `pt`: **"carvão"**
  ///
  /// **.crossHatching**
  ///
  /// `en`: **"cross-hatching"**
  ///
  /// `pt`: **"hachura cruzada"**
  ///
  /// **.lastSeparator**
  ///
  /// `en`: **" and "**
  ///
  /// `pt`: **" e "**
  ///
  /// **.pencil**
  ///
  /// `en`: **"pencil"**
  ///
  /// `pt`: **"lápis"**
  ///
  /// **.separator**
  ///
  /// `en`: **", "**
  ///
  /// `pt`: **", "**
  ///
  /// **.stippleBrush**
  ///
  /// `en`: **"stipple-brush"**
  ///
  /// `pt`: **"pontilhismo com pincel"**
  ///
  /// **.watercolor**
  ///
  /// `en`: **"watercolor"**
  ///
  /// `pt`: **"aquarela"**
  ///
  /// **.woodblock**
  ///
  /// `en`: **"woodblock"**
  ///
  /// `pt`: **"xilogravura"**
  ///
  ModularLocalizationInternalClass4 get effects => const ModularLocalizationInternalClass4();
}

class ModularLocalizationInternalClass4 implements ModularLocalization {
  const ModularLocalizationInternalClass4();

  /// `en`: **"charcoal"**
  ///
  /// `pt`: **"carvão"**
  ///
  String get charcoal => ModularLocalization.entries.entry10;

  /// `en`: **"cross-hatching"**
  ///
  /// `pt`: **"hachura cruzada"**
  ///
  String get crossHatching => ModularLocalization.entries.entry11;

  /// `en`: **" and "**
  ///
  /// `pt`: **" e "**
  ///
  String get lastSeparator => ModularLocalization.entries.entry12;

  /// `en`: **"pencil"**
  ///
  /// `pt`: **"lápis"**
  ///
  String get pencil => ModularLocalization.entries.entry13;

  /// `en`: **", "**
  ///
  /// `pt`: **", "**
  ///
  String get separator => ModularLocalization.entries.entry14;

  /// `en`: **"stipple-brush"**
  ///
  /// `pt`: **"pontilhismo com pincel"**
  ///
  String get stippleBrush => ModularLocalization.entries.entry15;

  /// `en`: **"watercolor"**
  ///
  /// `pt`: **"aquarela"**
  ///
  String get watercolor => ModularLocalization.entries.entry16;

  /// `en`: **"woodblock"**
  ///
  /// `pt`: **"xilogravura"**
  ///
  String get woodblock => ModularLocalization.entries.entry17;

}

class ModularLocalizationInternalClass5 implements ModularLocalization {
  const ModularLocalizationInternalClass5();

  /// **.changeImage**
  ///
  /// `en`: **"Change image"**
  ///
  /// `pt`: **"Alterar imagem"**
  ///
  /// **.decrease**
  ///
  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  ///
  /// **.downloadImage**
  ///
  /// `en`: **"Download image"**
  ///
  /// `pt`: **"Baixar imagem"**
  ///
  /// **.generatePalette**
  ///
  /// `en`: **"Generate palette"**
  ///
  /// `pt`: **"Gerar paleta"**
  ///
  /// **.importPalette**
  ///
  /// `en`: **"Import palette"**
  ///
  /// `pt`: **"Importar paleta"**
  ///
  /// **.increase**
  ///
  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  ///
  ModularLocalizationInternalClass6 get fdogShaderControls => const ModularLocalizationInternalClass6();
  /// **.accept**
  ///
  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  ///
  /// **.body0**
  ///
  /// `en`: **"Generate a palette in the Oklab color space, with steadily increasing perceived lightness. Use the sliders to adjust the green–red and blue–yellow balance of the colors."**
  ///
  /// `pt`: **"Gere uma paleta no espaço de cores Oklab, com luminosidade percebida aumentando de forma constante. Use os sliders para ajustar o equilíbrio entre verde e vermelho e entre azul e amarelo."**
  ///
  /// **.body1**
  ///
  /// `en`: **"However, since there are many more robust palette generators available, you may prefer using the import tool instead."**
  ///
  /// `pt`: **"No entanto, como existem geradores de paletas muito mais robustos disponíveis, você pode preferir usar a ferramenta de importação."**
  ///
  /// **.close**
  ///
  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  ///
  /// **.decrease**
  ///
  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  ///
  /// **.increase**
  ///
  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  ///
  /// **.random**
  ///
  /// `en`: **"Random"**
  ///
  /// `pt`: **"Aleatório"**
  ///
  /// **.title**
  ///
  /// `en`: **"Generate Palette"**
  ///
  /// `pt`: **"Gerar Paleta"**
  ///
  ModularLocalizationInternalClass7 get paletteGenerateDialog => const ModularLocalizationInternalClass7();
  /// **.accept**
  ///
  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  ///
  /// **.body**
  ///
  /// `en`: **"Import a custom palette by entering hex color values, one per line. You must provide at least two colors for a valid palette."**
  ///
  /// `pt`: **"Importe uma paleta personalizada inserindo valores de cor hexadecimais, um por linha. Você deve fornecer pelo menos duas cores para uma paleta válida."**
  ///
  /// **.close**
  ///
  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  ///
  /// **.hint**
  ///
  /// `en`: **"Enter a list of hex values, one per line, e.g.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  /// `pt`: **"Insira uma lista de valores hexadecimais, um por linha, p. ex.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  /// **.title**
  ///
  /// `en`: **"Import Palette"**
  ///
  /// `pt`: **"Importar Paleta"**
  ///
  ModularLocalizationInternalClass8 get paletteImportDialog => const ModularLocalizationInternalClass8();
  /// **.toggleMusic**
  ///
  /// `en`: **"Toggle music"**
  ///
  /// `pt`: **"Ligar/desligar música"**
  ///
  ModularLocalizationInternalClass9 get soundButton => const ModularLocalizationInternalClass9();
}

class ModularLocalizationInternalClass6 implements ModularLocalization {
  const ModularLocalizationInternalClass6();

  /// `en`: **"Change image"**
  ///
  /// `pt`: **"Alterar imagem"**
  ///
  String get changeImage => ModularLocalization.entries.entry18;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  ///
  String get decrease => ModularLocalization.entries.entry19;

  /// `en`: **"Download image"**
  ///
  /// `pt`: **"Baixar imagem"**
  ///
  String get downloadImage => ModularLocalization.entries.entry20;

  /// `en`: **"Generate palette"**
  ///
  /// `pt`: **"Gerar paleta"**
  ///
  String get generatePalette => ModularLocalization.entries.entry21;

  /// `en`: **"Import palette"**
  ///
  /// `pt`: **"Importar paleta"**
  ///
  String get importPalette => ModularLocalization.entries.entry22;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  ///
  String get increase => ModularLocalization.entries.entry23;

}

class ModularLocalizationInternalClass7 implements ModularLocalization {
  const ModularLocalizationInternalClass7();

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  ///
  String get accept => ModularLocalization.entries.entry24;

  /// `en`: **"Generate a palette in the Oklab color space, with steadily increasing perceived lightness. Use the sliders to adjust the green–red and blue–yellow balance of the colors."**
  ///
  /// `pt`: **"Gere uma paleta no espaço de cores Oklab, com luminosidade percebida aumentando de forma constante. Use os sliders para ajustar o equilíbrio entre verde e vermelho e entre azul e amarelo."**
  ///
  String get body0 => ModularLocalization.entries.entry25;

  /// `en`: **"However, since there are many more robust palette generators available, you may prefer using the import tool instead."**
  ///
  /// `pt`: **"No entanto, como existem geradores de paletas muito mais robustos disponíveis, você pode preferir usar a ferramenta de importação."**
  ///
  String get body1 => ModularLocalization.entries.entry26;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  ///
  String get close => ModularLocalization.entries.entry27;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  ///
  String get decrease => ModularLocalization.entries.entry28;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  ///
  String get increase => ModularLocalization.entries.entry29;

  /// `en`: **"Random"**
  ///
  /// `pt`: **"Aleatório"**
  ///
  String get random => ModularLocalization.entries.entry30;

  /// `en`: **"Generate Palette"**
  ///
  /// `pt`: **"Gerar Paleta"**
  ///
  String get title => ModularLocalization.entries.entry31;

}

class ModularLocalizationInternalClass8 implements ModularLocalization {
  const ModularLocalizationInternalClass8();

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  ///
  String get accept => ModularLocalization.entries.entry32;

  /// `en`: **"Import a custom palette by entering hex color values, one per line. You must provide at least two colors for a valid palette."**
  ///
  /// `pt`: **"Importe uma paleta personalizada inserindo valores de cor hexadecimais, um por linha. Você deve fornecer pelo menos duas cores para uma paleta válida."**
  ///
  String get body => ModularLocalization.entries.entry33;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  ///
  String get close => ModularLocalization.entries.entry34;

  /// `en`: **"Enter a list of hex values, one per line, e.g.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  /// `pt`: **"Insira uma lista de valores hexadecimais, um por linha, p. ex.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  String get hint => ModularLocalization.entries.entry35;

  /// `en`: **"Import Palette"**
  ///
  /// `pt`: **"Importar Paleta"**
  ///
  String get title => ModularLocalization.entries.entry36;

}

class ModularLocalizationInternalClass9 implements ModularLocalization {
  const ModularLocalizationInternalClass9();

  /// `en`: **"Toggle music"**
  ///
  /// `pt`: **"Ligar/desligar música"**
  ///
  String get toggleMusic => ModularLocalization.entries.entry37;

}


