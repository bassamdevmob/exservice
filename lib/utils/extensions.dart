
extension CapExtension on String {
  // String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  // String get allInCaps => this.toUpperCase();

  // String get capitalizeFirstOfEach => this.split(" ").map((str) => str.inCaps).join(" ");

  String get firstCapLetter {
    if (this.isEmpty) return this;
    return this[0].toUpperCase();
  }

  String get camelCase {
    var arrStr = this.split(" ");
    return arrStr
        .getRange(0, arrStr.length < 2 ? arrStr.length : 2)
        .map((str) => str[0])
        .join()
        .toUpperCase();
  }
}