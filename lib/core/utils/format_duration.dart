extension DurationFormatter on Duration {
  String toHHMM() {
    return [
      inHours,
      inMinutes.remainder(60),
    ].map((seg) => seg.toString().padLeft(2, '0')).join(':');
  }
}