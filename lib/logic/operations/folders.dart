import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/folder.dart';

class FoldersDownloadOperation extends Operation<List<Folder>> {

  FoldersDownloadOperation () : super(
    orderItems: (value) {
      return value.reversed.toList();
    }
  );

  @override
  Future<List<Folder>> perform() {
    return AuthService().securedApi.getFolders();
  }

}