class GeneralAlert {
  final int _id;
  final DateTime _startTime;
  DateTime _finishTime;

  GeneralAlert(this._id, this._startTime, this._finishTime);

  int getId(){
    return _id;
  }
  DateTime getStartTime() {
    return _startTime;
  }

  DateTime getFinishTime() {
    return _finishTime;
  }

  void setFinishTime(int upOrDown) {
    _finishTime = _finishTime.add(Duration(minutes: upOrDown));
  }
}
