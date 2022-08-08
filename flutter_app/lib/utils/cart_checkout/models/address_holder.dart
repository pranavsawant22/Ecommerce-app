// ignore_for_file: prefer_interpolation_to_compose_strings

class AddressHolder {
  String addressId;
  String serialId;
  String name;
  String buildingInfo;
  String state;
  String city;
  String landmark;
  String pincode;

  AddressHolder(
      {required this.name,
      required this.addressId,
      required this.buildingInfo,
      required this.city,
      this.landmark = "",
      required this.pincode,
      required this.serialId,
      required this.state});
  String addressCreate() {
    String address = buildingInfo +
        " " +
        city +
        " " +
        pincode +
        " " +
        landmark +
        " " +
        state;
    return address;
  }
}
