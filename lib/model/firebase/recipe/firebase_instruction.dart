import 'package:cookly/constants.dart';
import 'package:cookly/model/entities/abstract/instruction_entity.dart';
import 'package:cookly/model/entities/abstract/recipe_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_instruction.g.dart';

@JsonSerializable(includeIfNull: false)
class FirebaseInstruction {
  @JsonKey(nullable: false)
  int step;
  @JsonKey(nullable: false)
  String text;
  @JsonKey(nullable: true)
  String imagePath;

  FirebaseInstruction({this.step, this.text, this.imagePath});

  factory FirebaseInstruction.fromJson(Map<String, dynamic> json) {
    var instance = _$FirebaseInstructionFromJson(json);
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseInstructionToJson(this);

  static Future<List<FirebaseInstruction>> from(RecipeEntity recipe) async {
    List<FirebaseInstruction> result = [];
    var items = await recipe.instructions;
    for (var item in items) {
      result.add(FirebaseInstruction.fromInstructionEntity(item));
    }

    return result;
  }

  FirebaseInstruction.fromInstructionEntity(InstructionEntity entity) {
    this.imagePath = entity.image;
    this.step = entity.step;
    this.text = entity.text;
  }
}

@JsonSerializable(includeIfNull: false)
class FirebaseInstructionDocument {
  @JsonKey(ignore: true)
  String documentID;
  @JsonKey(nullable: false)
  String recipeID;
  @JsonKey(toJson: kListToJson)
  List<FirebaseInstruction> instructions;

  FirebaseInstructionDocument(
      {this.documentID, this.recipeID, this.instructions});

  factory FirebaseInstructionDocument.fromJson(
      Map<String, dynamic> json, String id) {
    var instance = _$FirebaseInstructionDocumentFromJson(json);
    instance.documentID = id;
    return instance;
  }

  Map<String, dynamic> toJson() => _$FirebaseInstructionDocumentToJson(this);

  static from(List<FirebaseInstruction> instructions, String recipeID) {
    return FirebaseInstructionDocument(
        instructions: instructions, recipeID: recipeID);
  }
}