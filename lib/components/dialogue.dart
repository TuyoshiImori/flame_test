import 'package:flame/components.dart';
import 'package:flame_test/helpers/dialogue_text_component.dart';
import 'package:flame_test/ray_world_game.dart';

class Dialogue extends PositionComponent with HasGameRef<RayWorldGame> {
  TextBoxComponent characterTextComponent =
      TextBoxComponent(boxConfig: TextBoxConfig(maxWidth: 800));

  bool changeCharacter = true;
  final String text;
  PositionComponent specialEffect = PositionComponent();

  Dialogue(this.text);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    size = gameRef.size;
    add(DialogueTextComponent()
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(220, size.y)
      ..size = Vector2(size.x - 220, 200));
    add(specialEffect);
  }
}
