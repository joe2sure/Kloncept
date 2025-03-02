class PaymentApi {
  String? stripekey;
  String? stripesecret;
  String? paypalClientId;
  String? paypalSecret;
  String? paypalMode;
  String? instamojoApiKey;
  String? instamojoAuthToken;
  String? instamojoUrl;
  String? razorpayKey;
  String? razorpaySecret;
  String? paystackPublicKey;
  String? paystackSecret;
  String? paystackPayUrl;
  String? paystackMerchantEmail;
  String? paytmEnviroment;
  String? paytmMerchantId;
  String? paytmMerchantKey;
  String? paytmMerchantWebsite;
  String? paytmChannel;
  String? paytmIndustryType;
  BankDetails? bankDetails;
  AllKeys? allKeys;
  Upi? upi;

  PaymentApi(
      {this.stripekey,
      this.stripesecret,
      this.paypalClientId,
      this.paypalSecret,
      this.paypalMode,
      this.instamojoApiKey,
      this.instamojoAuthToken,
      this.instamojoUrl,
      this.razorpayKey,
      this.razorpaySecret,
      this.paystackPublicKey,
      this.paystackSecret,
      this.paystackPayUrl,
      this.paystackMerchantEmail,
      this.paytmEnviroment,
      this.paytmMerchantId,
      this.paytmMerchantKey,
      this.paytmMerchantWebsite,
      this.paytmChannel,
      this.paytmIndustryType,
      this.bankDetails,
      this.allKeys,
      this.upi});

  PaymentApi.fromJson(Map<String, dynamic> json) {
    stripekey = json['stripekey'];
    stripesecret = json['stripesecret'];
    paypalClientId = json['paypal_client_id'];
    paypalSecret = json['paypal_secret'];
    paypalMode = json['paypal_mode'];
    instamojoApiKey = json['instamojo_api_key'];
    instamojoAuthToken = json['instamojo_auth_token'];
    instamojoUrl = json['instamojo_url'];
    razorpayKey = json['razorpay_key'];
    razorpaySecret = json['razorpay_secret'];
    paystackPublicKey = json['paystack_public_key'];
    paystackSecret = json['paystack_secret'];
    paystackPayUrl = json['paystack_pay_url'];
    paystackMerchantEmail = json['paystack_merchant_email'];
    paytmEnviroment = json['paytm_enviroment'];
    paytmMerchantId = json['paytm_merchant_id'];
    paytmMerchantKey = json['paytm_merchant_key'];
    paytmMerchantWebsite = json['paytm_merchant_website'];
    paytmChannel = json['paytm_channel'];
    paytmIndustryType = json['paytm_industry_type'];
    bankDetails = json['bank_details'] != null
        ? new BankDetails.fromJson(json['bank_details'])
        : null;
    allKeys = json['all_keys'] != null
        ? new AllKeys.fromJson(json['all_keys'])
        : null;
    upi = json['upi'] != null ? new Upi.fromJson(json['upi']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stripekey'] = this.stripekey;
    data['stripesecret'] = this.stripesecret;
    data['paypal_client_id'] = this.paypalClientId;
    data['paypal_secret'] = this.paypalSecret;
    data['paypal_mode'] = this.paypalMode;
    data['instamojo_api_key'] = this.instamojoApiKey;
    data['instamojo_auth_token'] = this.instamojoAuthToken;
    data['instamojo_url'] = this.instamojoUrl;
    data['razorpay_key'] = this.razorpayKey;
    data['razorpay_secret'] = this.razorpaySecret;
    data['paystack_public_key'] = this.paystackPublicKey;
    data['paystack_secret'] = this.paystackSecret;
    data['paystack_pay_url'] = this.paystackPayUrl;
    data['paystack_merchant_email'] = this.paystackMerchantEmail;
    data['paytm_enviroment'] = this.paytmEnviroment;
    data['paytm_merchant_id'] = this.paytmMerchantId;
    data['paytm_merchant_key'] = this.paytmMerchantKey;
    data['paytm_merchant_website'] = this.paytmMerchantWebsite;
    data['paytm_channel'] = this.paytmChannel;
    data['paytm_industry_type'] = this.paytmIndustryType;
    if (this.bankDetails != null) {
      data['bank_details'] = this.bankDetails!.toJson();
    }
    if (this.allKeys != null) {
      data['all_keys'] = this.allKeys!.toJson();
    }
    if (this.upi != null) {
      data['upi'] = this.upi!.toJson();
    }
    return data;
  }
}

class BankDetails {
  int? id;
  String? bankName;
  String? ifcsCode;
  String? accountNumber;
  String? accountHolderName;
  String? swiftCode;
  String? bankEnable;
  String? createdAt;
  String? updatedAt;

  BankDetails(
      {this.id,
      this.bankName,
      this.ifcsCode,
      this.accountNumber,
      this.accountHolderName,
      this.swiftCode,
      this.bankEnable,
      this.createdAt,
      this.updatedAt});

  BankDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bank_name'];
    ifcsCode = json['ifcs_code'];
    accountNumber = json['account_number'];
    accountHolderName = json['account_holder_name'];
    swiftCode = json['swift_code'];
    bankEnable = json['bank_enable'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_name'] = this.bankName;
    data['ifcs_code'] = this.ifcsCode;
    data['account_number'] = this.accountNumber;
    data['account_holder_name'] = this.accountHolderName;
    data['swift_code'] = this.swiftCode;
    data['bank_enable'] = this.bankEnable;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AllKeys {
  String? mOLLIEKEY;
  String? sKRILLMERCHANTEMAIL;
  String? sKRILLAPIPASSWORD;
  String? sKRILLLOGOURL;
  String? rAVEPUBLICKEY;
  String? rAVESECRETKEY;
  String? rAVEENVIRONMENT;
  String? rAVELOGO;
  String? rAVEPREFIX;
  String? rAVECOUNTRY;
  String? rAVESECRETHASH;
  String? pAYUMERCHANTKEY;
  String? pAYUMERCHANTSALT;
  String? pAYUAUTHHEADER;
  bool? pAYUMONEYTRUE;
  String? cASHFREEAPPID;
  String? cASHFREESECRETKEY;
  String? cASHFREEENDPOINT;
  String? oMISEPUBLICKEY;
  String? oMISESECRETKEY;
  String? oMISEAPIVERSION;
  String? pAYHEREMERCHANTID;
  String? pAYHEREBUISNESSAPPCODE;
  String? pAYHEREAPPSECRET;
  String? pAYHEREMODE;

  AllKeys(
      {this.mOLLIEKEY,
      this.sKRILLMERCHANTEMAIL,
      this.sKRILLAPIPASSWORD,
      this.sKRILLLOGOURL,
      this.rAVEPUBLICKEY,
      this.rAVESECRETKEY,
      this.rAVEENVIRONMENT,
      this.rAVELOGO,
      this.rAVEPREFIX,
      this.rAVECOUNTRY,
      this.rAVESECRETHASH,
      this.pAYUMERCHANTKEY,
      this.pAYUMERCHANTSALT,
      this.pAYUAUTHHEADER,
      this.pAYUMONEYTRUE,
      this.cASHFREEAPPID,
      this.cASHFREESECRETKEY,
      this.cASHFREEENDPOINT,
      this.oMISEPUBLICKEY,
      this.oMISESECRETKEY,
      this.oMISEAPIVERSION,
      this.pAYHEREMERCHANTID,
      this.pAYHEREBUISNESSAPPCODE,
      this.pAYHEREAPPSECRET,
      this.pAYHEREMODE});

  AllKeys.fromJson(Map<String, dynamic> json) {
    mOLLIEKEY = json['MOLLIE_KEY'];
    sKRILLMERCHANTEMAIL = json['SKRILL_MERCHANT_EMAIL'];
    sKRILLAPIPASSWORD = json['SKRILL_API_PASSWORD'];
    sKRILLLOGOURL = json['SKRILL_LOGO_URL'];
    rAVEPUBLICKEY = json['RAVE_PUBLIC_KEY'];
    rAVESECRETKEY = json['RAVE_SECRET_KEY'];
    rAVEENVIRONMENT = json['RAVE_ENVIRONMENT'];
    rAVELOGO = json['RAVE_LOGO'];
    rAVEPREFIX = json['RAVE_PREFIX'];
    rAVECOUNTRY = json['RAVE_COUNTRY'];
    rAVESECRETHASH = json['RAVE_SECRET_HASH'];
    pAYUMERCHANTKEY = json['PAYU_MERCHANT_KEY'];
    pAYUMERCHANTSALT = json['PAYU_MERCHANT_SALT'];
    pAYUAUTHHEADER = json['PAYU_AUTH_HEADER'];
    pAYUMONEYTRUE = json['PAYU_MONEY_TRUE'];
    cASHFREEAPPID = json['CASHFREE_APP_ID'];
    cASHFREESECRETKEY = json['CASHFREE_SECRET_KEY'];
    cASHFREEENDPOINT = json['CASHFREE_END_POINT'];
    oMISEPUBLICKEY = json['OMISE_PUBLIC_KEY'];
    oMISESECRETKEY = json['OMISE_SECRET_KEY'];
    oMISEAPIVERSION = json['OMISE_API_VERSION'];
    pAYHEREMERCHANTID = json['PAYHERE_MERCHANT_ID'];
    pAYHEREBUISNESSAPPCODE = json['PAYHERE_BUISNESS_APP_CODE'];
    pAYHEREAPPSECRET = json['PAYHERE_APP_SECRET'];
    pAYHEREMODE = json['PAYHERE_MODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MOLLIE_KEY'] = this.mOLLIEKEY;
    data['SKRILL_MERCHANT_EMAIL'] = this.sKRILLMERCHANTEMAIL;
    data['SKRILL_API_PASSWORD'] = this.sKRILLAPIPASSWORD;
    data['SKRILL_LOGO_URL'] = this.sKRILLLOGOURL;
    data['RAVE_PUBLIC_KEY'] = this.rAVEPUBLICKEY;
    data['RAVE_SECRET_KEY'] = this.rAVESECRETKEY;
    data['RAVE_ENVIRONMENT'] = this.rAVEENVIRONMENT;
    data['RAVE_LOGO'] = this.rAVELOGO;
    data['RAVE_PREFIX'] = this.rAVEPREFIX;
    data['RAVE_COUNTRY'] = this.rAVECOUNTRY;
    data['RAVE_SECRET_HASH'] = this.rAVESECRETHASH;
    data['PAYU_MERCHANT_KEY'] = this.pAYUMERCHANTKEY;
    data['PAYU_MERCHANT_SALT'] = this.pAYUMERCHANTSALT;
    data['PAYU_AUTH_HEADER'] = this.pAYUAUTHHEADER;
    data['PAYU_MONEY_TRUE'] = this.pAYUMONEYTRUE;
    data['CASHFREE_APP_ID'] = this.cASHFREEAPPID;
    data['CASHFREE_SECRET_KEY'] = this.cASHFREESECRETKEY;
    data['CASHFREE_END_POINT'] = this.cASHFREEENDPOINT;
    data['OMISE_PUBLIC_KEY'] = this.oMISEPUBLICKEY;
    data['OMISE_SECRET_KEY'] = this.oMISESECRETKEY;
    data['OMISE_API_VERSION'] = this.oMISEAPIVERSION;
    data['PAYHERE_MERCHANT_ID'] = this.pAYHEREMERCHANTID;
    data['PAYHERE_BUISNESS_APP_CODE'] = this.pAYHEREBUISNESSAPPCODE;
    data['PAYHERE_APP_SECRET'] = this.pAYHEREAPPSECRET;
    data['PAYHERE_MODE'] = this.pAYHEREMODE;
    return data;
  }
}

class Upi {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? upiid;
  String? status;

  Upi(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.upiid,
      this.status});

  Upi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    upiid = json['upiid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['upiid'] = this.upiid;
    data['status'] = this.status;
    return data;
  }
}
