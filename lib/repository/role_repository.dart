import 'package:acteurs/model/role.dart';
import 'package:acteurs/service/role_service.dart';

class RoleRepository {
  Future<List<Role>> getRoles(int personId) async {
    final roles = await fetchRoles();

    roles.sort((b,a)=>switch((a.votes,b.votes)){
      (null, null) => 0,
      (null, _) => 1,
      (_, null) => -1,
      // (_, _) => b.votes!.compareTo(a.votes!)
      (final va? , final vb? ) => va.compareTo(vb)
    });

    return roles;
  }
}