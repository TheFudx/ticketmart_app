class AppVersion {
  final String versionName;
  final bool released;

  AppVersion({required this.versionName, required this.released});

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      versionName: json['version_name'],
      released: json['released'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version_name': versionName,
      'released': released,
    };
  }
}
