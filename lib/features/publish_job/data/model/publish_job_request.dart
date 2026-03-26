class PublishJobResponse {
  final String status;
  final JobData data;

  PublishJobResponse({required this.status, required this.data});

  factory PublishJobResponse.fromJson(Map<String, dynamic> json) => PublishJobResponse(
    status: json["status"],
    data: JobData.fromJson(json["data"]),
  );
}

class JobData {
  final String id;
  final String status;
  final double totalAmount;

  JobData({required this.id, required this.status, required this.totalAmount});

  factory JobData.fromJson(Map<String, dynamic> json) => JobData(
    id: json["_id"],
    status: json["status"],
    totalAmount: (json["payment"]["totalAmount"] as num).toDouble(),
  );
}