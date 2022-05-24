class GeneralAlert {
  final String _id;
  final DateTime _startTime;
  DateTime _finishTime;

  GeneralAlert(this._id, this._startTime, this._finishTime);

  String getId() {
    return _id;
  }

  DateTime getStartTime() {
    return _startTime;
  }

  DateTime getFinishTime() {
    return _finishTime;
  }

  void setFinishTime(int upOrDown) {
    if (upOrDown >= 0) {
      _finishTime = _finishTime.add(Duration(minutes: upOrDown));
    }
    else {
      _finishTime = _finishTime.subtract(Duration(minutes: (-1)*upOrDown));
    }
  }
}
