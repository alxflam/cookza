import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';
import 'package:collection/collection.dart';

abstract class ProfileDeleter {
  Future<void> delete();
}

class ProfileDeleterImpl implements ProfileDeleter {
  final FirebaseProvider firebase = sl.get<FirebaseProvider>();

  @override
  Future<void> delete() async {
    // delete meal plan groups and assigned meal plans
    await _deleteMealPlans();

    // delete recipe groups and assigned recipes
    await _deleteRecipes();
  }

  Future<void> _deleteMealPlans() async {
    var mealPlanGroups = await firebase.mealPlanCollectionsAsList();
    for (var mealPlanGroup in mealPlanGroups) {
      List<UserEntity> users = List.of(mealPlanGroup.users);
      users.removeWhere((element) => element.id == firebase.userUid);
      bool otherOwners = hasOtherUsers(users);
      if (otherOwners) {
        // only leave group
        await firebase.leaveMealPlanGroup(mealPlanGroup.id!);
      } else {
        // delete group (also deletes meal plan)
        await firebase.deleteMealPlanCollection(mealPlanGroup.id!);
      }
    }
  }

  bool hasOtherUsers(List<UserEntity> users) {
    var otherOwners =
        users.firstWhereOrNull((element) => element.type == USER_TYPE.USER);
    return otherOwners != null;
  }

  Future<void> _deleteRecipes() async {
    var recipeGroups = await firebase.recipeCollectionsAsList();
    for (var recipeGroup in recipeGroups) {
      List<UserEntity> users = List.of(recipeGroup.users);
      users.removeWhere((e) => e.id == firebase.userUid);
      if (hasOtherUsers(users)) {
        // leave group
        await firebase.leaveRecipeGroup(recipeGroup.id!);
      } else {
        // delete group and all associated recipes including their images
        await firebase.deleteRecipeCollection(recipeGroup.id!);
      }
    }
  }
}
