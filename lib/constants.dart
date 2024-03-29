import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookza/components/alert_dialog_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

/// App name
const kAppName = 'Cookza';
const kPlayStoreLink = 'market://details?id=com.flammer.cookza';
const kRepositoryLink = 'https://github.com/alxflam/cookza';
const kChangelogLink =
    'https://github.com/alxflam/cookza/blob/master/CHANGELOG.md';

/// Icons
const kWebAppData = FontAwesomeIcons.desktop;
const kNewRecipe = FontAwesomeIcons.circlePlus;
const kFavoriteRecipes = FontAwesomeIcons.star;
const kSettingsIcon = FontAwesomeIcons.gear;
const kShareAccountIcon = FontAwesomeIcons.handshake;
const kRecipesIconData = FontAwesomeIcons.bookOpen;
const kInstructionsIconData = FontAwesomeIcons.listOl;
const kLeftoversIconData = FontAwesomeIcons.recycle;
const kMarketplaceIconData = FontAwesomeIcons.globe;
const kMealPlannerIconData = FontAwesomeIcons.calendarDays;
const kShoppingListIconData = FontAwesomeIcons.cartShopping;
const kIngredientsIconData = FontAwesomeIcons.receipt;
const kSimilarRecipesIconData = FontAwesomeIcons.layerGroup;
const kInfoIconData = FontAwesomeIcons.info;
const kVeganIcon = FontAwesomeIcons.seedling;
const kVegetarianIcon = FontAwesomeIcons.cheese;
const kMeatIcon = FontAwesomeIcons.drumstickBite;
const kFishIcon = FontAwesomeIcons.fish;
const kSummerIcon = FontAwesomeIcons.sun;
const kWinterIcon = FontAwesomeIcons.snowflake;
const kPartyIcon = FontAwesomeIcons.champagneGlasses;
const kCookieIcon = FontAwesomeIcons.cookie;
const kCakeIcon = FontAwesomeIcons.cakeCandles;
const kSoupIcon = FontAwesomeIcons.mugHot;
const kSweetsIcon = FontAwesomeIcons.iceCream;
const kDrinkIcon = FontAwesomeIcons.martiniGlassCitrus;

const kVeganTag = 'vegan';
const kVegetarianTag = 'vegetarian';
const kFishTag = 'fish';
const kMeatTag = 'meat';

const kMinRecipeDuration = 0;
const kMaxRecipeDuration = 120;

int adaptRecipeDuration(final int duration) {
  var result = duration;
  if (result < kMinRecipeDuration) {
    result = kMinRecipeDuration;
  } else if (result > kMaxRecipeDuration) {
    result = kMaxRecipeDuration;
  }
  return result;
}

/// custom image assets
const kIconTransparent = 'assets/images/icon_transparent_small.png';

const kBulletCharacter = '\u2022';

/// tags
/// todo: read this mapping on startup from a json, then user can add and refine tags and associate icons
const kTagMap = {
  'vegan': kVeganIcon,
  'vegetarian': kVegetarianIcon,
  'meat': kMeatIcon,
  'fish': kFishIcon,
  'summer': kSummerIcon,
  'winter': kWinterIcon,
  'party': kPartyIcon,
  'cookie': kCookieIcon,
  'cake': kCakeIcon,
  'soup': kSoupIcon,
  'sweets': kSweetsIcon,
  'drink': kDrinkIcon,
};

/// units
const kUoMPortion = 'PTN';

/// json conversion
DateTime kDateFromJson(String date) {
  // if (date != null) {
  return kDateFormatter.parse(date);
  // } else {
  //   return null;
  // }
}

String kDateToJson(DateTime date) {
  // if (date != null) {
  return kDateFormatter.format(date);
  // } else {
  //   return null;
  // }
}

Timestamp kTimestampFromJson(dynamic val) {
  if (val is Timestamp) {
    return val;
  } else if (val is Map) {
    return Timestamp(val['_seconds'], val['_nanoseconds']);
  }
  throw 'timestamp can not be parsed';
}

dynamic kTimestampToJson(Timestamp val) {
  return val;
}

/// Workaround as the model changed:
/// rating used to be a simple int, now it is a map to allow for ratings for every user
Map<String, int> kRatingFromJson(dynamic val) {
  if (val is Map<String, int>) {
    return val;
  } else if (val is int) {
    return {};
  }
  return {};
}

/// formatter
var kDateFormatter = DateFormat('dd.MM.yyyy');
var kFileNameDateFormatter = DateFormat('dd_MM_yyyy');
var ingredientsAmountFormatter = NumberFormat('####0.00');

String kFormatAmount(double? amount) {
  if (amount == null || amount == 0) {
    return '';
  }

  return amount % 1 == 0
      ? amount.toInt().toString()
      : ingredientsAmountFormatter.format(amount);
}

/// functions
void kNotImplementedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const SimpleDialog(
      title: Text('Not implemented'),
      titlePadding: EdgeInsets.all(20),
    ),
  );
}

void kErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: AlertDialogTitle(title: title),
      content: Text(message),
      titlePadding: const EdgeInsets.all(20),
    ),
  );
}

// json transformation
dynamic kListToJson(List? list) {
  if (list != null) {
    return list.map((f) => f.toJson()).toList();
  } else {
    return null;
  }
}

/// textStyles

/// button styles
final ButtonStyle kRaisedGreenButtonStyle =
    ElevatedButton.styleFrom(backgroundColor: Colors.green);

final ButtonStyle kRaisedRedButtonStyle =
    ElevatedButton.styleFrom(backgroundColor: Colors.red);

final ButtonStyle kRaisedGreyButtonStyle =
    ElevatedButton.styleFrom(backgroundColor: Colors.grey);

final ButtonStyle kRaisedOrangeButtonStyle =
    ElevatedButton.styleFrom(backgroundColor: Colors.orange);
