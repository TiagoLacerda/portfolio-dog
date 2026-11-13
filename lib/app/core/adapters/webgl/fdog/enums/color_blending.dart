enum ColorBlending {
  none(0),
  linear(1),
  twoPointLinear(2),
  bicubic(3);

  final int shaderValue;

  const ColorBlending(this.shaderValue);
}
