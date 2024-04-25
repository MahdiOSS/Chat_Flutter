import 'package:dartz/dartz.dart';
import 'package:syriamaksab/features/chat/data/models/Ads_Contact_Entity.dart';
import 'package:syriamaksab/features/chat/data/models/User_Entity.dart';

import 'package:syriamaksab/features/chat/domain/repository/UserRepository.dart';

import '../data_sources/Remote/UserDataSource_Remote.dart';
import '../data_sources/UserDataSource.dart';

class UserRepositoryImpl implements UserRepository {
//for test
  UserDataSource userDataSource = UserDataSourceRemote();

  @override
  Future<Either<String, UserEntity>> loginUser(
      String email, String password) async {
    try {
      var response = await userDataSource.login(email, password);
      Map<String, dynamic> json = response.data['user'];
      UserEntity user = UserEntity.fromJson(json);
      return Right(user);
    } catch (ex) {
      return Left(ex.toString());
    }
  }

  @override
  Future<Either<String, List<AdsContactEntity>>> getAdsContact() async {
    try {
      var response = await userDataSource.getAdsContact();
      List<dynamic> json = response.data['contacts'];
      List<AdsContactEntity> adsContactList =
          json.map((item) => AdsContactEntity.fromJson(item)).toList();
      return Right(adsContactList);
    } catch (ex) {
      return Left(ex.toString());
    }
  }
}
