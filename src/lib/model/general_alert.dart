class GeneralAlert {
  final DateTime _startTime;
  DateTime _finishTime;

  GeneralAlert(this._startTime, this._finishTime);

  DateTime getStartTime() {
    return this._startTime;
  }

  DateTime getFinishTime() {
    return this._finishTime;
  }
}
