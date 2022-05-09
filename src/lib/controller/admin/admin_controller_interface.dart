import 'package:uni/model/entities/profile.dart';

abstract class AdminControllerInterface {
  Future<bool> isAdmin();
}