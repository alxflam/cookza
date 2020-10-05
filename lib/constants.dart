import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

/// App name
const kAppName = 'Cookza';
const kAppVersion = '2020-09-alpha';
const kPlayStoreLink = 'market://details?id=com.flammer.cookza';

/// Icons
const kAppIconData = Icons.local_dining;
const kWebAppData = FontAwesomeIcons.desktop;
const kNewRecipe = FontAwesomeIcons.plusSquare;
const kSettingsIcon = FontAwesomeIcons.cog;
const kShareAccountIcon = FontAwesomeIcons.handshake;
const kRecipesIconData = FontAwesomeIcons.bookOpen;
const kLeftoversIconData = FontAwesomeIcons.recycle;
const kMarketplaceIconData = FontAwesomeIcons.globe;
const kMealPlannerIconData = FontAwesomeIcons.calendarAlt;
const kShoppingListIconData = FontAwesomeIcons.shoppingCart;
const kIngredientsIconData = FontAwesomeIcons.seedling;
const kSimilarRecipesIconData = FontAwesomeIcons.compressAlt;
const kInfoIconData = FontAwesomeIcons.info;
const kVeganIcon = FontAwesomeIcons.seedling;
const kVegetarianIcon = FontAwesomeIcons.cheese;
const kMeatIcon = FontAwesomeIcons.drumstickBite;
const kFishIcon = FontAwesomeIcons.fish;
const kSummerIcon = FontAwesomeIcons.sun;
const kWinterIcon = FontAwesomeIcons.snowflake;
const kPartyIcon = FontAwesomeIcons.glassCheers;
const kCookieIcon = FontAwesomeIcons.cookie;
const kCakeIcon = FontAwesomeIcons.birthdayCake;
const kSoupIcon = FontAwesomeIcons.mugHot;
const kSweetsIcon = FontAwesomeIcons.iceCream;
const kDrinkIcon = FontAwesomeIcons.cocktail;

const kVeganTag = 'vegan';
const kVegetarianTag = 'vegetarian';
const kFishTag = 'fish';
const kMeatTag = 'meat';

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
  if (date != null) {
    return kDateFormatter.parse(date);
  } else {
    return null;
  }
}

String kDateToJson(DateTime date) {
  if (date != null) {
    return kDateFormatter.format(date);
  } else {
    return null;
  }
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

/// formatter
var kDateFormatter = DateFormat('dd.MM.yyyy');
var kFileNameDateFormatter = DateFormat('dd_MM_yyyy');

String kFormatAmount(double amount) {
  if (amount == null || amount == 0) {
    return '';
  }
  return amount % 1 == 0
      ? amount.toInt().toString()
      : amount.toStringAsFixed(2);
}

/// functions
void kNotImplementedDialog(BuildContext context) {
  showDialog(
    context: context,
    child: SimpleDialog(
      title: Text('Not implemented'),
      titlePadding: EdgeInsets.all(20),
    ),
  );
}

void kErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    child: AlertDialog(
      title: Text(title),
      content: Text(message),
      titlePadding: EdgeInsets.all(20),
    ),
  );
}

// json transformation
dynamic kListToJson(List list) {
  if (list != null) {
    return list.map((f) => f.toJson()).toList();
  } else {
    return null;
  }
}

/// textStyles
