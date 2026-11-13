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

  /// `en`: **"The "**
  ///
  /// `pt`: **"A "**
  String get entry3;

  /// `en`: **"Flow-Based Difference of Gaussians (FDoG)"**
  ///
  /// `pt`: **"Diferença de Gaussianas Baseada em Fluxo (FDoG)"**
  String get entry4;

  /// `en`: **" is an image processing technique that enables a wide range of stylizations, like "**
  ///
  /// `pt`: **" é uma técnica de processamento de imagens que possibilita uma ampla variedade de estilizações, como efeitos de "**
  String get entry5;

  /// `en`: **" effects."**
  ///
  /// `pt`: **"."**
  String get entry6;

  /// `en`: **"\n\nProposed by "**
  ///
  /// `pt`: **"\n\nProposta por "**
  String get entry7;

  /// `en`: **"Holger Winnemöller and his team"**
  ///
  /// `pt`: **"Holger Winnemöller e sua equipe"**
  String get entry8;

  /// `en`: **", it extends the traditional Difference of Gaussians (DoG) by approximating the structure tensor of the image using the Sobel operator, then guiding the filtering process so that blurring and edge enhancement occur along the natural flow of the image's features."**
  ///
  /// `pt`: **", ela amplia a técnica tradicional de Diferença de Gaussianas (DoG) ao aproximar o tensor de estrutura da imagem usando o operador de Sobel e, em seguida, orientar o processo de filtragem para que o desfoque e o realce de bordas ocorram ao longo do fluxo natural das características da imagem."**
  String get entry9;

  /// `en`: **"charcoal"**
  ///
  /// `pt`: **"carvão"**
  String get entry10;

  /// `en`: **"cross-hatching"**
  ///
  /// `pt`: **"hachura cruzada"**
  String get entry11;

  /// `en`: **" and "**
  ///
  /// `pt`: **" e "**
  String get entry12;

  /// `en`: **"pencil"**
  ///
  /// `pt`: **"lápis"**
  String get entry13;

  /// `en`: **", "**
  ///
  /// `pt`: **", "**
  String get entry14;

  /// `en`: **"stipple-brush"**
  ///
  /// `pt`: **"pontilhismo com pincel"**
  String get entry15;

  /// `en`: **"watercolor"**
  ///
  /// `pt`: **"aquarela"**
  String get entry16;

  /// `en`: **"woodblock"**
  ///
  /// `pt`: **"xilogravura"**
  String get entry17;

  /// `en`: **"Change image"**
  ///
  /// `pt`: **"Alterar imagem"**
  String get entry18;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  String get entry19;

  /// `en`: **"Download image"**
  ///
  /// `pt`: **"Baixar imagem"**
  String get entry20;

  /// `en`: **"Generate palette"**
  ///
  /// `pt`: **"Gerar paleta"**
  String get entry21;

  /// `en`: **"Import palette"**
  ///
  /// `pt`: **"Importar paleta"**
  String get entry22;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  String get entry23;

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  String get entry24;

  /// `en`: **"Generate a palette in the Oklab color space, with steadily increasing perceived lightness. Use the sliders to adjust the green–red and blue–yellow balance of the colors."**
  ///
  /// `pt`: **"Gere uma paleta no espaço de cores Oklab, com luminosidade percebida aumentando de forma constante. Use os sliders para ajustar o equilíbrio entre verde e vermelho e entre azul e amarelo."**
  String get entry25;

  /// `en`: **"However, since there are many more robust palette generators available, you may prefer using the import tool instead."**
  ///
  /// `pt`: **"No entanto, como existem geradores de paletas muito mais robustos disponíveis, você pode preferir usar a ferramenta de importação."**
  String get entry26;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  String get entry27;

  /// `en`: **"Decrease"**
  ///
  /// `pt`: **"Diminuir"**
  String get entry28;

  /// `en`: **"Increase"**
  ///
  /// `pt`: **"Aumentar"**
  String get entry29;

  /// `en`: **"Random"**
  ///
  /// `pt`: **"Aleatório"**
  String get entry30;

  /// `en`: **"Generate Palette"**
  ///
  /// `pt`: **"Gerar Paleta"**
  String get entry31;

  /// `en`: **"Accept"**
  ///
  /// `pt`: **"Confirmar"**
  String get entry32;

  /// `en`: **"Import a custom palette by entering hex color values, one per line. You must provide at least two colors for a valid palette."**
  ///
  /// `pt`: **"Importe uma paleta personalizada inserindo valores de cor hexadecimais, um por linha. Você deve fornecer pelo menos duas cores para uma paleta válida."**
  String get entry33;

  /// `en`: **"Close"**
  ///
  /// `pt`: **"Fechar"**
  String get entry34;

  /// `en`: **"Enter a list of hex values, one per line, e.g.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  ///
  /// `pt`: **"Insira uma lista de valores hexadecimais, um por linha, p. ex.:\n#000000\n#555555\n#AAAAAA\n#FFFFFF"**
  String get entry35;

  /// `en`: **"Import Palette"**
  ///
  /// `pt`: **"Importar Paleta"**
  String get entry36;

  /// `en`: **"Toggle music"**
  ///
  /// `pt`: **"Ligar/desligar música"**
  String get entry37;
}
