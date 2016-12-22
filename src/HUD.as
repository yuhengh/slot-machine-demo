package
{
    import starling.display.Button;
    import starling.display.Sprite;

    public class HUD extends Sprite
    {
        private var _button:Button;

        public function HUD()
        {
            var sprite:Sprite = Game.uiBuilder.create(JSON.parse(new EmbeddedLayouts.hud)) as Sprite;
            addChild(sprite);
        }
    }
}
