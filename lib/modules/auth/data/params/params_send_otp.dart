class ParamsRefreshToken {
  final String refreshToken;

  ParamsRefreshToken({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }
}
