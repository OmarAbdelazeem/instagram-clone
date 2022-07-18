class TimeLineScrollOffset {
  TimeLineScrollOffset._();

  static double _timelineOffset = 0.0;

  static void setTimelineOffset(double offset) {
    _timelineOffset = offset;
  }


  static double get timelineOffset => _timelineOffset;

}
