import 'dart:convert';

class StaffSectionModel {
  String? candidateName;
  String? candidateReference;
  String? invoiceClientReference;
  String? orgName;
  String? clientName;
  String? postcode;
  String? ward;
  String? clientReference;
  String? ourReference;
  String? poNumber;
  String? jobTitle;

  StaffSectionModel({
    this.candidateName,
    this.candidateReference,
    this.invoiceClientReference,
    this.orgName,
    this.clientName,
    this.postcode,
    this.ward,
    this.clientReference,
    this.ourReference,
    this.poNumber,
    this.jobTitle,
  });

  bool isEmpty() {
    return candidateName!.isEmpty || orgName!.isEmpty || jobTitle!.isEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'candidateName': candidateName,
      'candidateReference': candidateReference,
      'invoiceClientReference': invoiceClientReference,
      'orgName': orgName,
      'clientName': clientName,
      'postcode': postcode,
      'ward': ward,
      'clientReference': clientReference,
      'ourReference': ourReference,
      'poNumber': poNumber,
      'jobTitle': jobTitle,
    };
  }

  factory StaffSectionModel.fromMap(Map<String, dynamic> map) {
    return StaffSectionModel(
      candidateName: map['candidateName'],
      candidateReference: map['candidateReference'],
      invoiceClientReference: map['invoiceClientReference'],
      orgName: map['orgName'],
      clientName: map['clientName'],
      postcode: map['postcode'],
      ward: map['ward'],
      clientReference: map['clientReference'],
      ourReference: map['ourReference'],
      poNumber: map['poNumber'],
      jobTitle: map['jobTitle'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffSectionModel.fromJson(String source) =>
      StaffSectionModel.fromMap(json.decode(source));
}
