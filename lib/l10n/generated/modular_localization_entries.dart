import 'dart:math';

abstract class ModularLocalizationEntries {
  const ModularLocalizationEntries();

  /// Replaces matches of `RegExp(r'%s')` with given [arguments].
  ///
  /// **example:**
  /// ```dart
  /// print(replaceArguments('I love %s and %s!', ['cakes', 'pie'])) // 'I love cakes and pie!'
  /// ```
  String replaceArguments(
    String string, [
    List<String> arguments = const [],
  ]) {
    var regExp = RegExp(r'%s');

    // Lower between number of arguments and argument slots.
    var limit = min(arguments.length, regExp.allMatches(string).length);

    for (int i = 0; i < limit; i++) {
      string = string.replaceFirst(regExp, arguments[i]);
    }

    return string;
  }

  /// `en`: **"Dark/light mode"**
  ///
  /// `pt`: **"Modo claro/escuro"**
  String get entry0;

  /// `en`: **"Homepage"**
  ///
  /// `pt`: **"Página inicial"**
  String get entry1;

  /// `en`: **"Language"**
  ///
  /// `pt`: **"Idioma"**
  String get entry2;

  /// `en`: **"XDoG: An eXtended difference-of-Gaussians compendium including advanced image stylization"**
  ///
  /// `pt`: **"XDoG: An eXtended difference-of-Gaussians compendium including advanced image stylization"**
  String get entry3;

  /// `en`: **"The "**
  ///
  /// `pt`: **"A "**
  String get entry4;

  /// `en`: **"Flow-based eXtended Difference of Gaussians (XDoG)"**
  ///
  /// `pt`: **"Diferença de Gaussianas Estendida Baseada em Fluxo (XDoG)"**
  String get entry5;

  /// `en`: **" is an image stylization pipeline by "**
  ///
  /// `pt`: **" é um pipeline de estilização de imagens de "**
  String get entry6;

  /// `en`: **"Holger Winnemöller, Jan Eric Kyprianidis and Sven C. Olsen"**
  ///
  /// `pt`: **"Holger Winnemöller, Jan Eric Kyprianidis e Sven C. Olsen"**
  String get entry7;

  /// `en`: **", described in their paper "**
  ///
  /// `pt`: **", descrito no artigo "**
  String get entry8;

  /// `en`: **" (Computers & Graphics, 2012).\n\nIt starts by measuring how brightness changes around each pixel with the Sobel operator, and from those gradients builds a smoothed structure tensor, whose eigenvectors describe the local flow of edges in the image. Guided by that flow, it blurs across edges with a difference of Gaussians to find and enhance them, then blurs along edges so the resulting lines come out smooth and coherent. Thresholding and texturing the result yields stylizations like "**
  ///
  /// `pt`: **" (Computers & Graphics, 2012).\n\nEle começa medindo como o brilho varia ao redor de cada pixel com o operador de Sobel e, a partir desses gradientes, constrói um tensor de estrutura suavizado, cujos autovetores descrevem o fluxo local das bordas na imagem. Guiado por esse fluxo, ele desfoca transversalmente às bordas com uma diferença de Gaussianas para encontrá-las e realçá-las, e depois desfoca ao longo delas para que as linhas resultantes fiquem suaves e coerentes. Limiarizar e texturizar o resultado gera estilizações como efeitos de "**
  String get entry9;

  /// `en`: **" effects."**
  ///
  /// `pt`: **"."**
  String get entry10;

  /// `en`: **"charcoal"**
  ///
  /// `pt`: **"carvão"**
  String get entry11;

  /// `en`: **"cross-hatching"**
  ///
  /// `pt`: **"hachura cruzada"**
  String get entry12;

  /// `en`: **" and "**
  ///
  /// `pt`: **" e "**
  String get entry13;

  /// `en`: **"pencil"**
  ///
  /// `pt`: **"lápis"**
  String get entry14;

  /// `en`: **", "**
  ///
  /// `pt`: **", "**
  String get entry15;

  /// `en`: **"stipple-brush"**
  ///
  /// `pt`: **"pontilhismo com pincel"**
  String get entry16;

  /// `en`: **"watercolor"**
  ///
  /// `pt`: **"aquarela"**
  String get entry17;

  /// `en`: **"woodblock"**
  ///
  /// `pt`: **"xilogravura"**
  String get entry18;

  /// `en`: **"Change image"**
  ///
  /// `pt`: **"Alterar imagem"**
  String get entry19;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  String get entry20;

  /// `en`: **"Download image"**
  ///
  /// `pt`: **"Baixar imagem"**
  String get entry21;

  /// `en`: **"Generate palette"**
  ///
  /// `pt`: **"Gerar paleta"**
  String get entry22;

  /// `en`: **"Import palette"**
  ///
  /// `pt`: **"Importar paleta"**
  String get entry23;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  String get entry24;

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  String get entry25;

  /// `en`: **"Generate a palette in the Oklab color space, with steadily increasing perceived lightness. Use the sliders to adjust the green–red and blue–yellow balance of the colors."**
  ///
  /// `pt`: **"Gere uma paleta no espaço de cores Oklab, com luminosidade percebida aumentando de forma constante. Use os sliders para ajustar o equilíbrio entre verde e vermelho e entre azul e amarelo."**
  String get entry26;

  /// `en`: **"However, since there are many more robust palette generators available, you may prefer using the import tool instead."**
  ///
  /// `pt`: **"No entanto, como existem geradores de paletas muito mais robustos disponíveis, você pode preferir usar a ferramenta de importação."**
  String get entry27;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  String get entry28;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  String get entry29;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  String get entry30;

  /// `en`: **"Random"**
  ///
  /// `pt`: **"Aleatório"**
  String get entry31;

  /// `en`: **"Generate Palette"**
  ///
  /// `pt`: **"Gerar Paleta"**
  String get entry32;

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  String get entry33;

  /// `en`: **"Import a custom palette by entering hex color values, one per line. You must provide at least two colors for a valid palette."**
  ///
  /// `pt`: **"Importe uma paleta personalizada inserindo valores de cor hexadecimais, um por linha. Você deve fornecer pelo menos duas cores para uma paleta válida."**
  String get entry34;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  String get entry35;

  /// `en`: **"Enter a list of hex values, one per line, e.g.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  /// `pt`: **"Insira uma lista de valores hexadecimais, um por linha, p. ex.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  String get entry36;

  /// `en`: **"Import Palette"**
  ///
  /// `pt`: **"Importar Paleta"**
  String get entry37;

  /// `en`: **"Toggle music"**
  ///
  /// `pt`: **"Ligar/desligar música"**
  String get entry38;
}
