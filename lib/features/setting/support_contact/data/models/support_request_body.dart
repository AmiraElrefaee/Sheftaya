class SupportRequestBody {
  final String problemType;
  final String message;
  final String? imagePath;

  SupportRequestBody({
    required this.problemType,
    required this.message,
    this.imagePath,
  });
}