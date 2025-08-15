abstract class WebglException implements Exception {
  final String message;

  WebglException([this.message = '']);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when the platform doesn't support WebGL.
class WebglNotSupportedException extends WebglException {
  WebglNotSupportedException([super.message]);
}

/// Thrown when a shader fails to compile.
class ShaderCompilationException extends WebglException {
  ShaderCompilationException([super.message]);
}

/// Thrown when a shader program fails to link.
class ProgramLinkException extends WebglException {
  ProgramLinkException([super.message]);
}

/// Thrown when texture creation fails.
class TextureCreationException extends WebglException {
  TextureCreationException([super.message]);
}

/// Thrown when frame buffer creation fails.
class FrameBufferCreationException extends WebglException {
  FrameBufferCreationException([super.message]);
}
