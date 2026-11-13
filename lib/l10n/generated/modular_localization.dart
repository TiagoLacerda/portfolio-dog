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
  /// **.paper**
  ///
  /// `en`: **"XDoG: An eXtended difference-of-Gaussians compendium including advanced image stylization"**
  ///
  /// `pt`: **"XDoG: An eXtended difference-of-Gaussians compendium including advanced image stylization"**
  ///
  /// **.text0**
  ///
  /// `en`: **"The "**
  ///
  /// `pt`: **"A "**
  ///
  /// **.text1**
  ///
  /// `en`: **"Flow-based eXtended Difference of Gaussians (XDoG)"**
  ///
  /// `pt`: **"Diferença de Gaussianas Estendida Baseada em Fluxo (XDoG)"**
  ///
  /// **.text2**
  ///
  /// `en`: **" is an image stylization pipeline by "**
  ///
  /// `pt`: **" é um pipeline de estilização de imagens de "**
  ///
  /// **.text3**
  ///
  /// `en`: **"Holger Winnemöller, Jan Eric Kyprianidis and Sven C. Olsen"**
  ///
  /// `pt`: **"Holger Winnemöller, Jan Eric Kyprianidis e Sven C. Olsen"**
  ///
  /// **.text4**
  ///
  /// `en`: **", described in their paper "**
  ///
  /// `pt`: **", descrito no artigo "**
  ///
  /// **.text5**
  ///
  /// `en`: **" (Computers & Graphics, 2012).\n\nIt starts by measuring how brightness changes around each pixel with the Sobel operator, and from those gradients builds a smoothed structure tensor, whose eigenvectors describe the local flow of edges in the image. Guided by that flow, it blurs across edges with a difference of Gaussians to find and enhance them, then blurs along edges so the resulting lines come out smooth and coherent. Thresholding and texturing the result yields stylizations like "**
  ///
  /// `pt`: **" (Computers & Graphics, 2012).\n\nEle começa medindo como o brilho varia ao redor de cada pixel com o operador de Sobel e, a partir desses gradientes, constrói um tensor de estrutura suavizado, cujos autovetores descrevem o fluxo local das bordas na imagem. Guiado por esse fluxo, ele desfoca transversalmente às bordas com uma diferença de Gaussianas para encontrá-las e realçá-las, e depois desfoca ao longo delas para que as linhas resultantes fiquem suaves e coerentes. Limiarizar e texturizar o resultado gera estilizações como efeitos de "**
  ///
  /// **.text6**
  ///
  /// `en`: **" effects."**
  ///
  /// `pt`: **"."**
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

  /// `en`: **"XDoG: An eXtended difference-of-Gaussians compendium including advanced image stylization"**
  ///
  /// `pt`: **"XDoG: An eXtended difference-of-Gaussians compendium including advanced image stylization"**
  ///
  String get paper => ModularLocalization.entries.entry3;

  /// `en`: **"The "**
  ///
  /// `pt`: **"A "**
  ///
  String get text0 => ModularLocalization.entries.entry4;

  /// `en`: **"Flow-based eXtended Difference of Gaussians (XDoG)"**
  ///
  /// `pt`: **"Diferença de Gaussianas Estendida Baseada em Fluxo (XDoG)"**
  ///
  String get text1 => ModularLocalization.entries.entry5;

  /// `en`: **" is an image stylization pipeline by "**
  ///
  /// `pt`: **" é um pipeline de estilização de imagens de "**
  ///
  String get text2 => ModularLocalization.entries.entry6;

  /// `en`: **"Holger Winnemöller, Jan Eric Kyprianidis and Sven C. Olsen"**
  ///
  /// `pt`: **"Holger Winnemöller, Jan Eric Kyprianidis e Sven C. Olsen"**
  ///
  String get text3 => ModularLocalization.entries.entry7;

  /// `en`: **", described in their paper "**
  ///
  /// `pt`: **", descrito no artigo "**
  ///
  String get text4 => ModularLocalization.entries.entry8;

  /// `en`: **" (Computers & Graphics, 2012).\n\nIt starts by measuring how brightness changes around each pixel with the Sobel operator, and from those gradients builds a smoothed structure tensor, whose eigenvectors describe the local flow of edges in the image. Guided by that flow, it blurs across edges with a difference of Gaussians to find and enhance them, then blurs along edges so the resulting lines come out smooth and coherent. Thresholding and texturing the result yields stylizations like "**
  ///
  /// `pt`: **" (Computers & Graphics, 2012).\n\nEle começa medindo como o brilho varia ao redor de cada pixel com o operador de Sobel e, a partir desses gradientes, constrói um tensor de estrutura suavizado, cujos autovetores descrevem o fluxo local das bordas na imagem. Guiado por esse fluxo, ele desfoca transversalmente às bordas com uma diferença de Gaussianas para encontrá-las e realçá-las, e depois desfoca ao longo delas para que as linhas resultantes fiquem suaves e coerentes. Limiarizar e texturizar o resultado gera estilizações como efeitos de "**
  ///
  String get text5 => ModularLocalization.entries.entry9;

  /// `en`: **" effects."**
  ///
  /// `pt`: **"."**
  ///
  String get text6 => ModularLocalization.entries.entry10;

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
  String get charcoal => ModularLocalization.entries.entry11;

  /// `en`: **"cross-hatching"**
  ///
  /// `pt`: **"hachura cruzada"**
  ///
  String get crossHatching => ModularLocalization.entries.entry12;

  /// `en`: **" and "**
  ///
  /// `pt`: **" e "**
  ///
  String get lastSeparator => ModularLocalization.entries.entry13;

  /// `en`: **"pencil"**
  ///
  /// `pt`: **"lápis"**
  ///
  String get pencil => ModularLocalization.entries.entry14;

  /// `en`: **", "**
  ///
  /// `pt`: **", "**
  ///
  String get separator => ModularLocalization.entries.entry15;

  /// `en`: **"stipple-brush"**
  ///
  /// `pt`: **"pontilhismo com pincel"**
  ///
  String get stippleBrush => ModularLocalization.entries.entry16;

  /// `en`: **"watercolor"**
  ///
  /// `pt`: **"aquarela"**
  ///
  String get watercolor => ModularLocalization.entries.entry17;

  /// `en`: **"woodblock"**
  ///
  /// `pt`: **"xilogravura"**
  ///
  String get woodblock => ModularLocalization.entries.entry18;

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
  String get changeImage => ModularLocalization.entries.entry19;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  ///
  String get decrease => ModularLocalization.entries.entry20;

  /// `en`: **"Download image"**
  ///
  /// `pt`: **"Baixar imagem"**
  ///
  String get downloadImage => ModularLocalization.entries.entry21;

  /// `en`: **"Generate palette"**
  ///
  /// `pt`: **"Gerar paleta"**
  ///
  String get generatePalette => ModularLocalization.entries.entry22;

  /// `en`: **"Import palette"**
  ///
  /// `pt`: **"Importar paleta"**
  ///
  String get importPalette => ModularLocalization.entries.entry23;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  ///
  String get increase => ModularLocalization.entries.entry24;

}

class ModularLocalizationInternalClass7 implements ModularLocalization {
  const ModularLocalizationInternalClass7();

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  ///
  String get accept => ModularLocalization.entries.entry25;

  /// `en`: **"Generate a palette in the Oklab color space, with steadily increasing perceived lightness. Use the sliders to adjust the green–red and blue–yellow balance of the colors."**
  ///
  /// `pt`: **"Gere uma paleta no espaço de cores Oklab, com luminosidade percebida aumentando de forma constante. Use os sliders para ajustar o equilíbrio entre verde e vermelho e entre azul e amarelo."**
  ///
  String get body0 => ModularLocalization.entries.entry26;

  /// `en`: **"However, since there are many more robust palette generators available, you may prefer using the import tool instead."**
  ///
  /// `pt`: **"No entanto, como existem geradores de paletas muito mais robustos disponíveis, você pode preferir usar a ferramenta de importação."**
  ///
  String get body1 => ModularLocalization.entries.entry27;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  ///
  String get close => ModularLocalization.entries.entry28;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  ///
  String get decrease => ModularLocalization.entries.entry29;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  ///
  String get increase => ModularLocalization.entries.entry30;

  /// `en`: **"Random"**
  ///
  /// `pt`: **"Aleatório"**
  ///
  String get random => ModularLocalization.entries.entry31;

  /// `en`: **"Generate Palette"**
  ///
  /// `pt`: **"Gerar Paleta"**
  ///
  String get title => ModularLocalization.entries.entry32;

}

class ModularLocalizationInternalClass8 implements ModularLocalization {
  const ModularLocalizationInternalClass8();

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  ///
  String get accept => ModularLocalization.entries.entry33;

  /// `en`: **"Import a custom palette by entering hex color values, one per line. You must provide at least two colors for a valid palette."**
  ///
  /// `pt`: **"Importe uma paleta personalizada inserindo valores de cor hexadecimais, um por linha. Você deve fornecer pelo menos duas cores para uma paleta válida."**
  ///
  String get body => ModularLocalization.entries.entry34;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  ///
  String get close => ModularLocalization.entries.entry35;

  /// `en`: **"Enter a list of hex values, one per line, e.g.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  /// `pt`: **"Insira uma lista de valores hexadecimais, um por linha, p. ex.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  String get hint => ModularLocalization.entries.entry36;

  /// `en`: **"Import Palette"**
  ///
  /// `pt`: **"Importar Paleta"**
  ///
  String get title => ModularLocalization.entries.entry37;

}

class ModularLocalizationInternalClass9 implements ModularLocalization {
  const ModularLocalizationInternalClass9();

  /// `en`: **"Toggle music"**
  ///
  /// `pt`: **"Ligar/desligar música"**
  ///
  String get toggleMusic => ModularLocalization.entries.entry38;

}


