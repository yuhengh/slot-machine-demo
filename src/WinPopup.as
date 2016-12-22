package {
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.text.TextField;

    public class WinPopup extends Sprite
    {
        public var _root:Sprite;
        public var _winText:TextField;

        public function WinPopup()
        {
            Game.uiBuilder.create(JSON.parse(new EmbeddedLayouts.win_popup), true, this);

            Utils.centerToStage(_root);
            addChild(_root);
        }

        public function show(amount:int):void
        {
            _winText.text = amount.toString();

            Starling.juggler.delayCall(function():void{
                removeFromParent();
            }, 1);
        }
    }
}
