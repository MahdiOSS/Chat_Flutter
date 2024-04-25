import 'package:dartz/dartz.dart';
import 'package:syriamaksab/features/chat/data/models/Ads_Contact_Entity.dart';
import 'package:syriamaksab/features/chat/data/models/User_Entity.dart';

abstract class UserRepository {
  Future<Either<String,UserEntity>> loginUser(String email,String password);
  Future<Either<String,List<AdsContactEntity>>> getAdsContact();
}