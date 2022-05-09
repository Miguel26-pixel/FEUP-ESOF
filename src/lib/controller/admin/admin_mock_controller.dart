import 'package:uni/controller/admin/admin_controller_interface.dart';


class MockAdminController implements AdminControllerInterface{
    MockAdminController(){}
    
    @override
    Future<bool> isAdmin() {
        return Future.value(true);
    }
}