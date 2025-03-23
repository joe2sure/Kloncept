// class RealPaymentGatewayModel {
//    int? id;
//    String? name;
//    String? walletImage;
//    String? status;
//    String? image;
//    String? description;
//    bool? isActive;
//    String? detail;

//   RealPaymentGatewayModel( {
//     this.id,
//     this.name,
//     this.walletImage,
//     this.image,
//     this.description,
//     this.isActive,
//     this.detail,
//     this.status
//   });
// }


class RealPaymentGatewayModel{
  int id;
  String name;
  String walletImage;
  String status;

  String? description;
  String? detail;
  String? isActive;
  RealPaymentGatewayModel(this.id, this.name, this.walletImage, this.status, this.description, this.detail, this.isActive,);
}