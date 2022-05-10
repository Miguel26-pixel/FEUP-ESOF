class GeneralAlert {
  final DateTime _startTime;
  final DateTime _finishTime;

  GeneralAlert(this._startTime, this._finishTime);

  DateTime getStartTime() {
    return _startTime;
  }

  DateTime getFinishTime() {
    return _finishTime;
  }
}
