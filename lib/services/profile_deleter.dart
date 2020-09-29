import 'package:cookza/model/entities/abstract/user_entity.dart';
import 'package:cookza/services/firebase_provider.dart';
import 'package:cookza/services/flutter/service_locator.dart';

abstract class ProfileDeleter {
  Future<void> delete();
}

class ProfileDeleterImpl implements ProfileDeleter {
  final FirebaseProvider firebase = sl.get<FirebaseProvider>();

  @override
  Future<void> delete() async {
    // delete meal plan groups and assigned meal plans
    await deleteMealPlans();

    // delete recipe groups and assigned recipes
    await deleteRecipes();
  }

  Future<void> deleteMealPlans() async {
    var mealPlanGroups = await firebase.mealPlanCollectionsAsList();
    for (var mealPlanGroup in mealPlanGroups) {
      List<UserEntity> users = List.of(mealPlanGroup.users);
      users.remove(firebase.userUid);
      bool otherOwners = hasOtherUsers(users);
      if (otherOwners != null) {
        // only leave group
        await firebase.leaveMealPlanGroup(mealPlanGroup.id);
      } else {
        // delete group (also deletes meal plan)
        await firebase.deleteMealPlanCollection(mealPlanGroup.id);
      }
    }
  }

  bool hasOtherUsers(List<UserEntity> users) {
    var otherOwners = users.firstWhere(
        (element) => element.type == USER_TYPE.USER,
        orElse: () => null);
    return otherOwners != null;
  }

  Future<void> deleteRecipes() async {
    var recipeGroups = await firebase.recipeCollectionsAsList();
    for (var recipeGroup in recipeGroups) {
      List<UserEntity> users = List.of(recipeGroup.users);
      users.remove(firebase.userUid);
      if (hasOtherUsers(users)) {
        // leave group
        await firebase.leaveRecipeGroup(recipeGroup.id);
      } else {
        // delete group and all associated recipes including their images
        firebase.deleteRecipeCollection(recipeGroup.id);
      }
    }
  }
}
